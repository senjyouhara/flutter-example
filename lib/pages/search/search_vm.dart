import 'package:example/pages/search/search_model_entity.dart';
import 'package:flutter/cupertino.dart';
import '../../utils/request/request.dart';

class SearchViewModel with ChangeNotifier {

  List<SearchModelDatas> searchList = [];
  num pageTotal = 0;
  bool isPageEnd = false;

  Future search(String searchValue, int page)async {
    var result = await Request.post<SearchModelEntity>("/article/query/${page - 1}/json", queryParameters: {
      "k": searchValue,
    });
    if(page == 1){
      searchList = result.data?.datas ?? [];
    } else {
      searchList.addAll(result.data?.datas ?? []);
    }

    pageTotal = result.data?.total ?? 0;
    isPageEnd = (result.data?.pageCount ?? 0) <= (result.data?.curPage ?? 1);
    notifyListeners();
  }
}