
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';

class MyRequestInterceptor extends InterceptorsWrapper {


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // 记录请求信息
    print("===Request to: ${options.uri}");
    print("===Headers: ${options.headers}");
    print("===Body: ${options.data}");
    handler.next(options);
  }

  @override
  void onResponse(Response<dynamic> response,
      ResponseInterceptorHandler handler) {
    // 记录响应信息
    print("===Response from: ${response.requestOptions.uri}");
    print("===responseType: ${response.requestOptions.responseType}");
    print("===Status code: ${response.statusCode}");
    if([ResponseType.json, ResponseType.plain].contains(response.requestOptions.responseType)){
      print("===Data: ${response.data}");
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // 记录错误信息
    print("===Error: ${err.message}");
    print("===Error type: ${err.type}");
    formatError(err);
    handler.next(err);
  }

  ///  error统一处理
  void formatError(DioException e) {
    if (e.type == DioExceptionType.connectionTimeout) {
      print("===连接超时");
      showToast("连接超时");
    } else if (e.type == DioExceptionType.sendTimeout) {
      print("===请求超时");
      showToast("请求超时");
    } else if (e.type == DioExceptionType.receiveTimeout) {
      print("===响应超时");
      showToast("响应超时");
    } else if (e.type == DioExceptionType.badResponse) {
      print('===服务器响应错误，状态码：${e.response?.statusCode}');
    } else if (e.type == DioExceptionType.cancel) {
      print("===请求取消");
    } else if (e.type == DioExceptionType.connectionError) {
      print("===连接错误");
      showToast("连接错误");
    } else if (e.type == DioExceptionType.unknown) {
      print("===未知错误, ${e.message}");
      showToast("未知错误, ${e.message}");
    } else {
      print("===message =${e.message}");
      showToast("${e.message}");
    }
  }
}