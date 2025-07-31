import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import 'home_list_model.dart';
import 'home_model.dart';

class HomeViewModel with ChangeNotifier {

  List<HomeModelData> bannerData = [];
  List<HomeListData> listData = [];

  Future getBanner()async {
    Dio dio = Dio();
    dio.options = BaseOptions(
        connectTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        baseUrl: 'https://www.wanandroid.com',
        method: 'GET',
    );
    var response = await dio.get("/banner/json");

    var data = HomeModel.fromJson(response.data);

    if(data?.errorCode == 0 && data.data != null && data.data!.isNotEmpty){
      bannerData = data.data!;
    } else {
      bannerData = [];
    }

    notifyListeners();
  }

  Future getListData()async {
    Dio dio = Dio();
    dio.options = BaseOptions(
        connectTimeout: Duration(seconds: 30),
        sendTimeout: Duration(seconds: 30),
        receiveTimeout: Duration(seconds: 30),
        baseUrl: 'https://www.wanandroid.com',
        method: 'GET',
    );
    var response = await dio.get("/article/list/0/json");

    var data = HomeListModel.fromJson(response.data);

    if(data?.errorCode == 0 && data.data != null && data.data?.datas != null){
      listData = data.data!.datas!;
    } else {
      listData = [];
    }

    notifyListeners();
  }

}