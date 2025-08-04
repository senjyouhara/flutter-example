import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/login_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/login_model_entity.g.dart';

@JsonSerializable()
class LoginModelEntity {
	bool? admin;
	int? coinCount;
	List<num>? collectIds;
	String? email;
	String? icon;
	int? id;
	String? nickname;
	String? password;
	String? publicName;
	String? token;
	int? type;
	String? username;

	LoginModelEntity();

	factory LoginModelEntity.fromJson(Map<String, dynamic> json) => $LoginModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $LoginModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}