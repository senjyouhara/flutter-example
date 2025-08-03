import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/hot_key/friend_model_entity.dart';

FriendModelEntity $FriendModelEntityFromJson(Map<String, dynamic> json) {
  final FriendModelEntity friendModelEntity = FriendModelEntity();
  final String? category = jsonConvert.convert<String>(json['category']);
  if (category != null) {
    friendModelEntity.category = category;
  }
  final String? icon = jsonConvert.convert<String>(json['icon']);
  if (icon != null) {
    friendModelEntity.icon = icon;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    friendModelEntity.id = id;
  }
  final String? link = jsonConvert.convert<String>(json['link']);
  if (link != null) {
    friendModelEntity.link = link;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    friendModelEntity.name = name;
  }
  final int? order = jsonConvert.convert<int>(json['order']);
  if (order != null) {
    friendModelEntity.order = order;
  }
  final int? visible = jsonConvert.convert<int>(json['visible']);
  if (visible != null) {
    friendModelEntity.visible = visible;
  }
  return friendModelEntity;
}

Map<String, dynamic> $FriendModelEntityToJson(FriendModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['category'] = entity.category;
  data['icon'] = entity.icon;
  data['id'] = entity.id;
  data['link'] = entity.link;
  data['name'] = entity.name;
  data['order'] = entity.order;
  data['visible'] = entity.visible;
  return data;
}

extension FriendModelEntityExtension on FriendModelEntity {
  FriendModelEntity copyWith({
    String? category,
    String? icon,
    int? id,
    String? link,
    String? name,
    int? order,
    int? visible,
  }) {
    return FriendModelEntity()
      ..category = category ?? this.category
      ..icon = icon ?? this.icon
      ..id = id ?? this.id
      ..link = link ?? this.link
      ..name = name ?? this.name
      ..order = order ?? this.order
      ..visible = visible ?? this.visible;
  }
}