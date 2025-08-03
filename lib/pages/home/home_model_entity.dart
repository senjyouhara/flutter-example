import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/home_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/home_model_entity.g.dart';

@JsonSerializable()
class HomeModelEntity {
	String? desc;
	int? id;
	String? imagePath;
	int? isVisible;
	int? order;
	String? title;
	int? type;
	String? url;

	HomeModelEntity();

	factory HomeModelEntity.fromJson(Map<String, dynamic> json) => $HomeModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $HomeModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}