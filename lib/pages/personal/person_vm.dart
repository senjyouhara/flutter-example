import 'package:flutter/cupertino.dart';
import '../../utils/request/request.dart';

class PersonViewModel with ChangeNotifier {


  Future getFriendData()async {
    // var res = await Request.get<List<FriendModelEntity>>("/friend/json");
    // friendData = res.data ?? [];
    notifyListeners();
  }


}