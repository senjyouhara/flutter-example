import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/hot_key_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/hot_key_model_entity.g.dart';

@JsonSerializable()
class HotKeyModelEntity {
	int? id;
	String? link;
	String? name;
	int? order;
	int? visible;

	HotKeyModelEntity();

	factory HotKeyModelEntity.fromJson(Map<String, dynamic> json) => $HotKeyModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $HotKeyModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}