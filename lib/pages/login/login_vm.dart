import 'package:flutter/cupertino.dart';
import '../../utils/request/request.dart';
import 'login_model_entity.dart';

class LoginViewModel with ChangeNotifier {

  LoginModelEntity? userInfo;

  Future<LoginModelEntity> login(String username, String password)async {
    var result = await Request.post<LoginModelEntity>("/user/login", queryParameters: {
      "username": username,
      "password": password,
    });
    userInfo = result.data!;
    notifyListeners();
    return result.data!;
  }
}