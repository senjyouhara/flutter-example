
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:example/utils/sp_util.dart';

import '../../constants/sp_constants.dart';

class CookieInterceptor extends Interceptor {


  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler)async {
    var cookies = await SpUtil.getStringList(SpConstants.cookies) ?? [];

    if (!options.path.endsWith('/user/login') && cookies.isNotEmpty) {
      options.headers[HttpHeaders.cookieHeader] = cookies;
    }

    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) async {

    if(response.requestOptions.path.endsWith("/user/login")){
      dynamic setCookies = response.headers[HttpHeaders.setCookieHeader];
      List<String> cookies = [];
      if (setCookies is List) {
        for (String? cookie in setCookies) {
          debugPrint('cookie interceptor cookie: $cookie');
          if (cookie?.isNotEmpty == true) {
            cookies.add(cookie!);
          }
        }
      }
      if (cookies.isNotEmpty) {
        await SpUtil.setStringList(SpConstants.cookies, cookies);
      }
    }

    handler.next(response);

  }


}