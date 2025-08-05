import 'package:flutter/cupertino.dart';
import '../../constants/Sp_constants.dart';
import '../../utils/request/request.dart';
import '../../utils/sp_util.dart';
import 'login_model_entity.dart';

class LoginViewModel with ChangeNotifier {

  LoginModelEntity? userInfo;

  Future getInfo() async {
    var userInfoMap = await SpUtil.getMap(SpConstants.userInfo);
    if(userInfoMap?.isNotEmpty == true){
      userInfo = LoginModelEntity.fromJson(userInfoMap!);
      notifyListeners();
    }
  }

  Future<LoginModelEntity> login(String username, String password)async {
    var result = await Request.post<LoginModelEntity>("/user/login", queryParameters: {
      "username": username,
      "password": password,
    });
    userInfo = result.data!;
    notifyListeners();
    return result.data!;
  }

  void logout() async {
    await Request.get("/user/logout/json");
    await SpUtil.remove(SpConstants.userInfo);
    await SpUtil.remove(SpConstants.cookies);
    userInfo = null;
    notifyListeners();
  }
}