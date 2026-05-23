# Type Safety

> Type and model rules for the Flutter client.

---

## Overview

This project uses Dart types plus generated JSON conversion helpers. Typed API consumption is centered on:

- feature-local entity classes such as `LoginModelEntity` and `HomeModelEntity`
- shared response envelope `BaseModelEntity<T>`
- generated serializers in `lib/generated/json/`

The goal is to keep parsing logic out of pages and VMs.

---

## Type Organization

### Feature models

Put API-facing model classes next to the feature that uses them.

Examples:

- `lib/pages/login/login_model_entity.dart`
- `lib/pages/home/home_model_entity.dart`
- `lib/pages/knowledge/knowledge_model_entity.dart`

### Shared envelope and generated code

- `lib/utils/request/base_model_entity.dart` defines the common response envelope
- `lib/generated/json/` contains generated serialization support
- `export 'package:example/generated/json/...';` is used by model files to expose generated helpers

Do not move all models into one global `models/` folder unless the whole codebase is reorganized intentionally.

---

## Parsing Contract

Use typed request calls:

```dart
final res = await Request.get<List<HomeModelEntity>>('/banner/json');
final login = await Request.post<LoginModelEntity>('/user/login', queryParameters: {
  'username': username,
  'password': password,
});
```

Rules:

1. choose the concrete `T` at the call site
2. let `Request` and `BaseModelEntity<T>` perform parsing
3. assign typed data into VM fields
4. keep widgets consuming typed fields, not raw maps

`Request` has explicit special handling for primitive values and `List<T>`-style generic payloads. If a new payload shape cannot be represented cleanly, update the shared parsing layer instead of adding ad-hoc JSON traversal in pages.

---

## Validation

Runtime response validation is split across two layers:

1. `MyResponseInterceptor` validates the API envelope semantics (`errorCode`, `errorMsg`)
2. `BaseModelEntity<T>` and generated converters map `data` into typed entities

This means page and VM code should treat a fulfilled request as already envelope-validated.

---

## Common Patterns

### One feature, one model family

Keep related entities together in the feature folder when they are part of the same screen flow.

### Generic request return type

Every request should declare the intended data type through the generic parameter.

### Generated file boundary

Hand-written entity files define fields and constructors; generated files provide conversion code.

---

## Forbidden Patterns

### Don’t parse JSON maps directly in widgets

```dart
final name = response.data['data']['username'];
```

Use a typed entity instead.

### Don’t edit generated files

Never hand-edit anything under `lib/generated/json/`. Regenerate instead.

### Don’t erase types with `dynamic` unless the payload is genuinely dynamic

A feature that knows its response shape should declare a concrete entity type.

### Don’t duplicate the API envelope inside each feature

Use `BaseModelEntity<T>` as the shared wrapper.

---

## Wrong vs Correct

### Wrong

```dart
final response = await Request.get('/banner/json');
final firstImage = response.data[0]['imagePath'];
```

### Correct

```dart
final response = await Request.get<List<HomeModelEntity>>('/banner/json');
final firstImage = response.data?.first.imagePath;
```
