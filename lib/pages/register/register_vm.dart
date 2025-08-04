import 'package:flutter/cupertino.dart';
import '../../utils/request/request.dart';

class RegisterViewModel with ChangeNotifier {

  Future<bool> register(String username, String password, String repassword)async {
    var result = await Request.post("/user/register", queryParameters: {
      "username": username,
      "password": password,
      "repassword": repassword,
    });
    return result.data != null;
  }
}