import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:example/pages/home/home_top_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/request/base_model_entity.dart';
import '../../utils/request/request.dart';
import 'home_list_model.dart';
import 'home_model.dart';

class HomeViewModel with ChangeNotifier {

  List<HomeModelData> bannerData = [];
  List<HomeListData> listData = [];
  num pageTotal = 0;
  bool isPageEnd = false;
  List<HomeTopListModel> topListData = [];

  Future getBanner()async {

    var res = await Request.get<List<HomeModelData>>("/banner/json");
    bannerData = res.data ?? [];
    notifyListeners();
  }

  Future getListData(num page)async {
    var res = await Request.get<HomeListDatas>("/article/list/${page - 1}/json");

    if(page == 1){
      listData = res.data?.datas ?? [];
    } else {
      listData.addAll(res.data?.datas ?? []);
    }

    pageTotal = res.data?.total ?? 0;
    isPageEnd = (res.data?.pageCount ?? 0) <= (res.data?.curPage ?? 1);
    notifyListeners();
  }

  Future getTopListData()async {
    var res = await Request.get<List<HomeTopListModel>>("/article/top/json");
    topListData = res.data ?? [];
    notifyListeners();
  }

}