import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/hot_key/hot_key_model_entity.dart';

HotKeyModelEntity $HotKeyModelEntityFromJson(Map<String, dynamic> json) {
  final HotKeyModelEntity hotKeyModelEntity = HotKeyModelEntity();
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    hotKeyModelEntity.id = id;
  }
  final String? link = jsonConvert.convert<String>(json['link']);
  if (link != null) {
    hotKeyModelEntity.link = link;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    hotKeyModelEntity.name = name;
  }
  final int? order = jsonConvert.convert<int>(json['order']);
  if (order != null) {
    hotKeyModelEntity.order = order;
  }
  final int? visible = jsonConvert.convert<int>(json['visible']);
  if (visible != null) {
    hotKeyModelEntity.visible = visible;
  }
  return hotKeyModelEntity;
}

Map<String, dynamic> $HotKeyModelEntityToJson(HotKeyModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['id'] = entity.id;
  data['link'] = entity.link;
  data['name'] = entity.name;
  data['order'] = entity.order;
  data['visible'] = entity.visible;
  return data;
}

extension HotKeyModelEntityExtension on HotKeyModelEntity {
  HotKeyModelEntity copyWith({
    int? id,
    String? link,
    String? name,
    int? order,
    int? visible,
  }) {
    return HotKeyModelEntity()
      ..id = id ?? this.id
      ..link = link ?? this.link
      ..name = name ?? this.name
      ..order = order ?? this.order
      ..visible = visible ?? this.visible;
  }
}