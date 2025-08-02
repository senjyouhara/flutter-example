
import 'dart:developer';

import 'package:dio/dio.dart';

class MyRequestInterceptor extends InterceptorsWrapper {


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    super.onRequest(options, handler);

  }

  @override
  void onResponse(Response<dynamic> response,
      ResponseInterceptorHandler handler) {
    log("response  path: ${response.realUri.path}, data: ${response.data}");
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    log("response error  path: ${err.response?.realUri.path}, error: ${err}");
    formatError(err);
    super.onError(err, handler);
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
      print(e.hashCode.toString() + "出现异常404 503");
    } else if (e.type == DioExceptionType.cancel) {
      print(e.hashCode.toString() + "请求取消");
    } else {
      print("message =${e.message}");
    }
  }



}