import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../utils/request/request.dart';

final registerActionProvider = Provider<RegisterAction>((ref) {
  return RegisterAction();
});

class RegisterAction {
  Future<bool> register(String username, String password, String repassword) async {
    final result = await Request.post(
      '/user/register',
      queryParameters: {
        'username': username,
        'password': password,
        'repassword': repassword,
      },
    );
    return result.data != null;
  }
}
