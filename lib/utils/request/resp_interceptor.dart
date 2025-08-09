
import 'package:dio/dio.dart';
import 'package:oktoast/oktoast.dart';

import 'base_model_entity.dart';

class MyResponseInterceptor extends  Interceptor {


  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if(response.statusCode == 200){
      try {
        if(![ResponseType.json, ResponseType.plain].contains(response.requestOptions.responseType)) {
          handler.next(Response(requestOptions: response.requestOptions, data: response.data));
          return;
        }

        if(response.requestOptions.path.startsWith("http")){
          handler.next(Response(requestOptions: response.requestOptions, data: response.data));
          return;
        }

        var model = BaseModelEntity.fromJson(response.data);
        if(model.errorCode == 0){
          handler.next(Response(requestOptions: response.requestOptions, data: response.data));
        } else {
          if(model.errorCode == -1001){
            showToast("用户未登录");
            handler.reject(DioException(requestOptions: response.requestOptions, message: "未登录"));
          } else {
            showToast(model.errorMsg?.isNotEmpty == true ? model.errorMsg! : "未知错误");
            handler.reject(DioException(requestOptions: response.requestOptions, message: model.errorMsg?.isNotEmpty == true ? model.errorMsg! : "未知错误"));
          }
        }
      } catch (err){
        handler.reject(DioException(requestOptions: response.requestOptions, message: "$err"));
        showToast("$err");
      }
    } else {
      handler.reject(DioException(requestOptions: response.requestOptions));
    }
  }
}