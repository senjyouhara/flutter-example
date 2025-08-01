import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/request/base_model_entity.dart';
import '../../utils/request/request.dart';
import 'home_list_model.dart';
import 'home_model.dart';

class HomeViewModel with ChangeNotifier {

  List<HomeModelData> bannerData = [];
  List<HomeListData> listData = [];

  Future getBanner()async {

    var res = await Request.get<List<HomeModelData>>("/banner/json");
    if(res.data != null && res.data!.isNotEmpty){
      bannerData = res.data!;
    } else {
      bannerData = [];
    }

    notifyListeners();
  }

  Future getListData()async {
    var res = await Request.get<HomeListDatas>("/article/list/0/json");

    if(res.data != null){
      listData = res.data!.datas! ?? [];
    } else {
      listData = [];
    }

    notifyListeners();
  }

}