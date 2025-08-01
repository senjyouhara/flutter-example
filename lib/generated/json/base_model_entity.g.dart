import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/utils/request/base_model_entity.dart';

BaseModelEntity $BaseModelEntityFromJson<T>(Map<String, dynamic> json) {
  final BaseModelEntity baseModelEntity = BaseModelEntity();
  final int? errorCode = jsonConvert.convert<int>(json['errorCode']);
  if (errorCode != null) {
    baseModelEntity.errorCode = errorCode;
  }
  final String? errorMsg = jsonConvert.convert<String>(json['errorMsg']);
  if (errorMsg != null) {
    baseModelEntity.errorMsg = errorMsg;
  }
  final T data = json['data'];
  if (data != null) {
    baseModelEntity.data = data;
  }
  return baseModelEntity;
}

Map<String, dynamic> $BaseModelEntityToJson(BaseModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['errorCode'] = entity.errorCode;
  data['errorMsg'] = entity.errorMsg;
  data['data'] = entity.data;
  return data;
}

extension BaseModelEntityExtension on BaseModelEntity {
  BaseModelEntity copyWith({
    int? errorCode,
    String? errorMsg,
    dynamic data,
  }) {
    return BaseModelEntity()
      ..errorCode = errorCode ?? this.errorCode
      ..errorMsg = errorMsg ?? this.errorMsg
      ..data = data ?? this.data;
  }
}