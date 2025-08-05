import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:example/utils/request/cookie_interceptor.dart';
import 'package:example/utils/request/request_interceptor.dart';
import 'package:example/utils/request/resp_interceptor.dart';

import 'base_model_entity.dart';

class Request {
  static String _baseUrl = "https://www.wanandroid.com";

  // 单位秒
  static int _timeout = 300;

  Request._();

  static Future<BaseModelEntity<T>> get<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      url,
      "GET",
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<BaseModelEntity<T>> post<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      url,
      "POST",
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<BaseModelEntity<T>> put<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      url,
      "PUT",
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<BaseModelEntity<T>> delete<T>(
    String url, {
    Object? data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) {
    return _request<T>(
      url,
      "DELETE",
      data: data,
      queryParameters: queryParameters,
      options: options,
      cancelToken: cancelToken,
    );
  }

  static Future<BaseModelEntity<T>> _request<T>(
    String url,
    String method, {
    Map<String, dynamic>? queryParameters,
    Object? data,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    Dio dio = Dio();
    dio.options = BaseOptions(
      connectTimeout: Duration(seconds: _timeout),
      sendTimeout: Duration(seconds: _timeout),
      receiveTimeout: Duration(seconds: _timeout),
      baseUrl: _baseUrl,
      method: method,
    );
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
    dio.interceptors.add(CookieInterceptor());
    dio.interceptors.add(MyRequestInterceptor());
    dio.interceptors.add(MyResponseInterceptor());

    Response response;

    if (method == "GET") {
      response = await dio.get(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } else if (method == "PUT") {
      response = await dio.put(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } else if (method == "DELETE") {
      response = await dio.delete(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    } else {
      response = await dio.post(
        url,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
    }
    return BaseModelEntity<T>.fromJson(response.data);
  }
}
