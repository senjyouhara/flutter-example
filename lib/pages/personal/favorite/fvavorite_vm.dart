import 'package:flutter/cupertino.dart';

import '../../../utils/request/request.dart';
import '../../home/home_list_model_entity.dart';

class FavoriteViewModel with ChangeNotifier {

  List<HomeListModelDatas> listData = [];
  num pageTotal = 0;
  bool isPageEnd = false;

  Future getListData(num page)async {
    var res = await Request.get<HomeListModelEntity>("/lg/collect/list/${page - 1}/json");

    if(page == 1){
      listData = res.data?.datas ?? [];
    } else {
      listData.addAll(res.data?.datas ?? []);
    }

    listData.forEach((item){
      item.collect = true;
    });

    pageTotal = res.data?.total ?? 0;
    isPageEnd = (res.data?.pageCount ?? 0) <= (res.data?.curPage ?? 1);
    notifyListeners();
  }



  Future delCollectPost(String id)async {
    return Request.post("/lg/uncollect_originId/${id}/json");
  }

  Future updateListData(int index)async{
    listData.removeAt(index);
    notifyListeners();
  }

}