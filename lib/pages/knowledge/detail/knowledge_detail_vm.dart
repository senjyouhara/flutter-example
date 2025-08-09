import 'package:flutter/cupertino.dart';

import '../../../utils/request/request.dart';
import '../knowledge_menuTree_model_entity.dart';
import '../knowledge_model_entity.dart';

class KnowledgeDetailViewModel with ChangeNotifier {
  List<KnowledgeModelDatas> listData = [];
  List<KnowledgeMenuTreeModelEntity> menuTreeData = [];
  num pageTotal = 0;
  bool isPageEnd = false;
  int? id;
  int? pid;

  Future getMenuTree() async {
    var res = await Request.get<List<KnowledgeMenuTreeModelEntity>>(
      "/tree/json",
    );
    menuTreeData = res.data ?? [];
    notifyListeners();
  }

  Future getListData(num page, {num? cid, String? author}) async {

    if(page == 1){
      listData = [];
      notifyListeners();
    }

    var res = await Request.get<KnowledgeModelEntity>(
      "/article/list/${page - 1}/json?${cid != null ? '&cid=' + cid.toString() : ''}${author != null ? '&author=' + author : ''}",
    );

    if (page == 1) {
      listData = res.data?.datas ?? [];
    } else {
      listData.addAll(res.data?.datas ?? []);
    }

    listData.forEach((item) {
      item.collect = true;
    });

    pageTotal = res.data?.total ?? 0;
    isPageEnd = (res.data?.pageCount ?? 0) <= (res.data?.curPage ?? 1);
    notifyListeners();
  }

  Future updateListData(KnowledgeModelDatas item, int index) async {
    listData[index] = item;
    notifyListeners();
  }
}
