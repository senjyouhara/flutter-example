import 'package:flutter/cupertino.dart';
import '../../utils/request/request.dart';
import 'friend_model_entity.dart';
import 'hot_key_model_entity.dart';

class HotKeyViewModel with ChangeNotifier {

  List<FriendModelEntity> friendData = [];
  List<HotKeyModelEntity> hotKeyData = [];

  Future getFriendData()async {
    var res = await Request.get<List<FriendModelEntity>>("/friend/json");
    friendData = res.data ?? [];
    notifyListeners();
  }

  Future getHotKeyData()async {
    var res = await Request.get<List<HotKeyModelEntity>>("/hotkey/json");
    hotKeyData = res.data ?? [];
    notifyListeners();
  }

}