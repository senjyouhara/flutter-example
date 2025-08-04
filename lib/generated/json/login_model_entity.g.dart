import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/login/login_model_entity.dart';

LoginModelEntity $LoginModelEntityFromJson(Map<String, dynamic> json) {
  final LoginModelEntity loginModelEntity = LoginModelEntity();
  final bool? admin = jsonConvert.convert<bool>(json['admin']);
  if (admin != null) {
    loginModelEntity.admin = admin;
  }
  final int? coinCount = jsonConvert.convert<int>(json['coinCount']);
  if (coinCount != null) {
    loginModelEntity.coinCount = coinCount;
  }
  final List<num>? collectIds = (json['collectIds'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<num>(e) as num).toList();
  if (collectIds != null) {
    loginModelEntity.collectIds = collectIds;
  }
  final String? email = jsonConvert.convert<String>(json['email']);
  if (email != null) {
    loginModelEntity.email = email;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    loginModelEntity.icon = icon;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    loginModelEntity.id = id;
  }
  final String? nickname = jsonConvert.convert<String>(json['nickname']);
  if (nickname != null) {
    loginModelEntity.nickname = nickname;
  }
  final String? password = jsonConvert.convert<String>(json['password']);
  if (password != null) {
    loginModelEntity.password = password;
  }
  final String? publicName = jsonConvert.convert<String>(json['publicName']);
  if (publicName != null) {
    loginModelEntity.publicName = publicName;
  }
  final String? token = jsonConvert.convert<String>(json['token']);
  if (token != null) {
    loginModelEntity.token = token;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    loginModelEntity.type = type;
  }
  final String? username = jsonConvert.convert<String>(json['username']);
  if (username != null) {
    loginModelEntity.username = username;
  }
  return loginModelEntity;
}

Map<String, dynamic> $LoginModelEntityToJson(LoginModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['admin'] = entity.admin;
  data['coinCount'] = entity.coinCount;
  data['collectIds'] = entity.collectIds;
  data['email'] = entity.email;
  data['icon'] = entity.icon;
  data['id'] = entity.id;
  data['nickname'] = entity.nickname;
  data['password'] = entity.password;
  data['publicName'] = entity.publicName;
  data['token'] = entity.token;
  data['type'] = entity.type;
  data['username'] = entity.username;
  return data;
}

extension LoginModelEntityExtension on LoginModelEntity {
  LoginModelEntity copyWith({
    bool? admin,
    int? coinCount,
    List<num>? collectIds,
    String? email,
    String? icon,
    int? id,
    String? nickname,
    String? password,
    String? publicName,
    String? token,
    int? type,
    String? username,
  }) {
    return LoginModelEntity()
      ..admin = admin ?? this.admin
      ..coinCount = coinCount ?? this.coinCount
      ..collectIds = collectIds ?? this.collectIds
      ..email = email ?? this.email
      ..icon = icon ?? this.icon
      ..id = id ?? this.id
      ..nickname = nickname ?? this.nickname
      ..password = password ?? this.password
      ..publicName = publicName ?? this.publicName
      ..token = token ?? this.token
      ..type = type ?? this.type
      ..username = username ?? this.username;
  }
}