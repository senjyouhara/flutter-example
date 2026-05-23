# Networking & API Contracts

> Shared request-layer contract for the Flutter client.

---

## Scenario: Shared API access through `Request`

### 1. Scope / Trigger

- Trigger: any new or changed API integration
- Trigger: any change to response parsing, auth session handling, cookie persistence, or downloads
- Trigger: any feature that reads or writes WanAndroid data through HTTP

All network access in active feature code must go through `lib/utils/request/request.dart` plus its interceptors.

### 2. Signatures

#### Request entry points

```dart
static Future<BaseModelEntity<T>> get<T>(String url, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
})

static Future<BaseModelEntity<T>> post<T>(String url, {
  Object? data,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onSendProgress,
  ProgressCallback? onReceiveProgress,
})

static Future<BaseModelEntity<T>> put<T>(String url, {...})
static Future<BaseModelEntity<T>> delete<T>(String url, {...})
static Future<BaseModelEntity<T>> download<T>(String url, {
  String? method = 'GET',
  Object? data,
  dynamic savePath,
  Map<String, dynamic>? queryParameters,
  Options? options,
  CancelToken? cancelToken,
  ProgressCallback? onReceiveProgress,
})
```

#### Shared response envelope

```dart
class BaseModelEntity<T> {
  int? errorCode;
  String? errorMsg;
  T? data;
}
```

#### Shared persistence keys

```dart
SpConstants.cookies
SpConstants.userInfo
```

### 3. Contracts

#### Request contract

- Relative URLs are sent against base URL `https://www.wanandroid.com`.
- Standard API calls expect WanAndroid-style envelope fields: `errorCode`, `errorMsg`, `data`.
- Typed payload parsing is selected by the generic parameter `T`.
- Interceptors applied to every request:
  - `CookieInterceptor()`
  - `MyRequestInterceptor()`
  - `MyResponseInterceptor()`

#### Response contract

- Success is defined as HTTP 200 plus `errorCode == 0` for standard JSON/plain-text app endpoints.
- For external absolute URLs (`url.startsWith('http')`) returning non-JSON content, `Request` may return an empty `BaseModelEntity<T>` instead of forcing JSON parsing.
- Download requests default `responseType` to `ResponseType.bytes` unless explicitly overridden.

#### Persistence contract

- login success persists `userInfo` through `SpUtil.setMap(SpConstants.userInfo, result.toJson())`
- logout clears `SpConstants.userInfo` and `SpConstants.cookies`
- feature code must not invent duplicate storage keys outside `SpConstants`

### 4. Validation & Error Matrix

| Condition | Behavior |
|-----------|----------|
| HTTP 200 + `errorCode == 0` | pass response through as success |
| HTTP 200 + `errorCode == -1001` | show toast `用户未登录`, reject `DioException(message: '未登录')` |
| HTTP 200 + `errorCode != 0` and not `-1001` | show `errorMsg` or `未知错误`, reject `DioException` |
| HTTP 200 + external absolute URL + non-JSON response | do not envelope-parse; return raw/non-envelope path |
| HTTP 200 + response type not `json` / `plain` | skip envelope validation path |
| non-200 response | reject `DioException` |
| `connectionTimeout` | toast `连接超时` |
| `sendTimeout` | toast `请求超时` |
| `receiveTimeout` | toast `响应超时` |
| `connectionError` | toast `连接错误` |
| `unknown` error | toast `未知错误, <message>` |

### 5. Good / Base / Bad Cases

#### Good

```dart
final result = await Request.post<LoginModelEntity>(
  '/user/login',
  queryParameters: {
    'username': username,
    'password': password,
  },
);
```

- typed payload
- shared interceptors active
- envelope validation preserved

#### Base

```dart
final file = await Request.download<Uint8List>(
  'https://example.com/file.apk',
  savePath: targetPath,
);
```

- absolute URL is allowed
- caller must understand this is not a WanAndroid envelope response
- response type should stay bytes-oriented for downloads

#### Bad

```dart
final dio = Dio();
final response = await dio.get('/banner/json');
final data = response.data['data'];
```

- bypasses cookie, logging, error, and envelope rules
- duplicates parsing in feature code

### 6. Tests Required

#### Unit

- `MyResponseInterceptor` success case: HTTP 200 + `errorCode == 0` reaches `handler.next`
- unauthenticated case: HTTP 200 + `errorCode == -1001` rejects with `未登录`
- business error case: HTTP 200 + non-zero `errorCode` rejects with message
- non-200 case rejects
- `BaseModelEntity<T>.fromJson()` maps `errorCode`, `errorMsg`, and typed `data`

#### Integration

- login flow stores `SpConstants.userInfo` after successful `Request.post<LoginModelEntity>`
- logout flow clears `SpConstants.userInfo` and `SpConstants.cookies`
- a paginated list request maps envelope data into the expected entity type

#### Widget / manual assertions

- login page dismisses loading after success and failure
- collect / uncollect actions update visible UI after VM mutation
- route navigation still works when response handling succeeds

### 7. Wrong vs Correct

#### Wrong

```dart
Future<void> login(String username, String password) async {
  final dio = Dio();
  final response = await dio.post(
    'https://www.wanandroid.com/user/login',
    queryParameters: {
      'username': username,
      'password': password,
    },
  );
  userInfo = LoginModelEntity.fromJson(response.data['data']);
}
```

#### Correct

```dart
Future<LoginModelEntity> login(String username, String password) async {
  final result = await Request.post<LoginModelEntity>(
    '/user/login',
    queryParameters: {
      'username': username,
      'password': password,
    },
  );
  userInfo = result.data!;
  notifyListeners();
  return result.data!;
}
```
