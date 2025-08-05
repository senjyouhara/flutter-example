import 'package:example/pages/home/home_top_list_model.dart';
import 'package:flutter/cupertino.dart';

import '../../utils/request/request.dart';
import 'home_list_model_entity.dart';
import 'home_model_entity.dart';

class HomeViewModel with ChangeNotifier {

  List<HomeModelEntity> bannerData = [];
  List<HomeListModelDatas> listData = [];
  num pageTotal = 0;
  bool isPageEnd = false;
  List<HomeTopListModel> topListData = [];

  Future updateListData(HomeListModelDatas item,int index)async{
    listData[index] = item;
    notifyListeners();
  }

  Future getBanner()async {

    var res = await Request.get<List<HomeModelEntity>>("/banner/json");
    bannerData = res.data ?? [];
    notifyListeners();
  }

  Future getListData(num page)async {
    var res = await Request.get<HomeListModelEntity>("/article/list/${page - 1}/json");

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

  Future collectInnerPost(String id)async {
    return Request.post("/lg/collect/${id}/json");
  }

  Future collectOuterPost(String title, String author, String link)async {
    return Request.post("/lg/collect/add/json", queryParameters: {
      "title": title,
      "author": author,
      "link": link,
    });
  }

  Future delCollectPost(String id)async {
    return Request.post("/lg/uncollect_originId/${id}/json");
  }

}