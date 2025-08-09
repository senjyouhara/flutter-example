import 'package:flutter/cupertino.dart';

import '../../utils/request/request.dart';
import 'knowledge_menuTree_model_entity.dart';
import 'knowledge_model_entity.dart';

class KnowledgeViewModel with ChangeNotifier {
  List<KnowledgeMenuTreeModelEntity> menuTreeData = [];

  Future getMenuTree() async {
    var res = await Request.get<List<KnowledgeMenuTreeModelEntity>>(
      "/tree/json",
    );
    menuTreeData = res.data ?? [];
    notifyListeners();
  }
}
