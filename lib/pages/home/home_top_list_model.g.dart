// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_top_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeTopListModel _$HomeTopListModelFromJson(Map<String, dynamic> json) =>
    HomeTopListModel()
      ..articleList = json['articleList'] as List<dynamic>?
      ..author = json['author'] as String?
      ..children = (json['children'] as List<dynamic>?)
          ?.map((e) => HomeTopListModel.fromJson(e as Map<String, dynamic>))
          .toList()
      ..courseId = json['courseId'] as num?
      ..cover = json['cover'] as String?
      ..desc = json['desc'] as String?
      ..id = json['id'] as num?
      ..lisense = json['lisense'] as String?
      ..lisenseLink = json['lisenseLink'] as String?
      ..name = json['name'] as String?
      ..order = json['order'] as num?
      ..parentChapterId = json['parentChapterId'] as num?
      ..type = json['type'] as num?
      ..userControlSetTop = json['userControlSetTop'] as bool?
      ..visible = json['visible'] as num?;

Map<String, dynamic> _$HomeTopListModelToJson(HomeTopListModel instance) =>
    <String, dynamic>{
      'articleList': instance.articleList,
      'author': instance.author,
      'children': instance.children,
      'courseId': instance.courseId,
      'cover': instance.cover,
      'desc': instance.desc,
      'id': instance.id,
      'lisense': instance.lisense,
      'lisenseLink': instance.lisenseLink,
      'name': instance.name,
      'order': instance.order,
      'parentChapterId': instance.parentChapterId,
      'type': instance.type,
      'userControlSetTop': instance.userControlSetTop,
      'visible': instance.visible,
    };
