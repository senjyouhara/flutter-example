import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../constants/sp_constants.dart';
import '../../utils/request/request.dart';
import '../../utils/sp_util.dart';
import 'login_model_entity.dart';

final authProvider = NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);

class AuthState {
  const AuthState({this.userInfo});

  final LoginModelEntity? userInfo;

  bool get isLoggedIn => userInfo != null;

  AuthState copyWith({
    LoginModelEntity? userInfo,
    bool clearUserInfo = false,
  }) {
    return AuthState(
      userInfo: clearUserInfo ? null : (userInfo ?? this.userInfo),
    );
  }
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() {
    final userInfoMap = SpUtil.getMap(SpConstants.userInfo);
    if (userInfoMap?.isNotEmpty == true) {
      return AuthState(userInfo: LoginModelEntity.fromJson(userInfoMap!));
    }
    return const AuthState();
  }

  Future<LoginModelEntity> login(String username, String password) async {
    final result = await Request.post<LoginModelEntity>(
      '/user/login',
      queryParameters: {
        'username': username,
        'password': password,
      },
    );
    final userInfo = result.data!;
    await SpUtil.setMap(SpConstants.userInfo, userInfo.toJson());
    state = AuthState(userInfo: userInfo);
    return userInfo;
  }

  Future<void> logout() async {
    await Request.get('/user/logout/json');
    await SpUtil.remove(SpConstants.userInfo);
    await SpUtil.remove(SpConstants.cookies);
    state = const AuthState();
  }
}
