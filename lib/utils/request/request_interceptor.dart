
import 'dart:developer';

import 'package:dio/dio.dart';

class MyRequestInterceptor extends InterceptorsWrapper {


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 记录请求信息
    print("Request to: ${options.uri}");
    print("Headers: ${options.headers}");
    print("Body: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response,
      ResponseInterceptorHandler handler) {
    // 记录响应信息
    print("Response from: ${response.requestOptions.uri}");
    print("Status code: ${response.statusCode}");
    print("Data: ${response.data}");
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 记录错误信息
    print("Error: ${err.message}");
    print("Error type: ${err.type}");
    formatError(err);
    handler.next(err);
  }

  ///  error统一处理
  void formatError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      print(e.hashCode.toString() + "连接超时");
    } else if (e.type == DioExceptionType.sendTimeout) {
      print(e.hashCode.toString() + "请求超时");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      print(e.hashCode.toString() + "响应超时");
    } else if (e.type == DioExceptionType.badResponse) {
      print(e.hashCode.toString() + '服务器响应错误，状态码：${e.response?.statusCode}');
    } else if (e.type == DioExceptionType.cancel) {
      print(e.hashCode.toString() + "请求取消");
    } else if (e.type == DioExceptionType.connectionError) {
      print(e.hashCode.toString() + "连接错误");
    } else if (e.type == DioExceptionType.unknown) {
      print(e.hashCode.toString() + "未知错误, ${e.message}");
    } else {
      print("message =${e.message}");
    }
  }
}