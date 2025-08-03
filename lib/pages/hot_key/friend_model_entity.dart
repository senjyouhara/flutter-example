import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/friend_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/friend_model_entity.g.dart';

@JsonSerializable()
class FriendModelEntity {
	String? category;
	String? icon;
	int? id;
	String? link;
	String? name;
	int? order;
	int? visible;

	FriendModelEntity();

	factory FriendModelEntity.fromJson(Map<String, dynamic> json) => $FriendModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $FriendModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}