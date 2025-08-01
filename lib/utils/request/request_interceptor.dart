
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
    super.onError(err, handler);

  }


}