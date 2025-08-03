import 'package:example/generated/json/base/json_field.dart';
import 'dart:convert';
export 'package:example/generated/json/base_model_entity.g.dart';
import 'package:example/generated/json/base/json_convert_content.dart';

@JsonSerializable()
class BaseModelEntity<T> {
  int? errorCode;
  String? errorMsg;
  T? data;

  BaseModelEntity();

  BaseModelEntity.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null && json['data'] != 'null') {
      data = JsonConvert.fromJsonAsT<T>(json['data']);
    }
    errorCode = json['errorCode'];
    errorMsg = json['errorMsg'];
  }

	Map<String, dynamic> toJson() {
		final Map<String, dynamic> data = new Map<String, dynamic>();
		if (this.data != null) {
			data['data'] = this.data;
		}
		data['errorCode'] = this.errorCode;
		data['errorMsg'] = this.errorMsg;
		return data;
	}
  @override
  String toString() {
    return jsonEncode(this);
  }
}
