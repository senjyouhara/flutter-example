import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/knowledge/knowledge_menuTree_model_entity.dart';

KnowledgeMenuTreeModelEntity $KnowledgeMenuTreeModelEntityFromJson(
    Map<String, dynamic> json) {
  final KnowledgeMenuTreeModelEntity knowledgeMenuTreeModelEntity = KnowledgeMenuTreeModelEntity();
  final List<dynamic>? articleList = (json['articleList'] as List<dynamic>?)
      ?.map(
          (e) => e)
      .toList();
  if (articleList != null) {
    knowledgeMenuTreeModelEntity.articleList = articleList;
  }
  final String? author = jsonConvert.convert<String>(json['author']);
  if (author != null) {
    knowledgeMenuTreeModelEntity.author = author;
  }
  final List<
      KnowledgeMenuTreeModelEntity>? children = (json['children'] as List<
      dynamic>?)?.map(
          (e) =>
      jsonConvert.convert<KnowledgeMenuTreeModelEntity>(
          e) as KnowledgeMenuTreeModelEntity).toList();
  if (children != null) {
    knowledgeMenuTreeModelEntity.children = children;
  }
  final int? courseId = jsonConvert.convert<int>(json['courseId']);
  if (courseId != null) {
    knowledgeMenuTreeModelEntity.courseId = courseId;
  }
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    knowledgeMenuTreeModelEntity.cover = cover;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    knowledgeMenuTreeModelEntity.desc = desc;
  }
  final int? id = jsonConvert.convert<int>(json['id']);
  if (id != null) {
    knowledgeMenuTreeModelEntity.id = id;
  }
  final String? lisense = jsonConvert.convert<String>(json['lisense']);
  if (lisense != null) {
    knowledgeMenuTreeModelEntity.lisense = lisense;
  }
  final String? lisenseLink = jsonConvert.convert<String>(json['lisenseLink']);
  if (lisenseLink != null) {
    knowledgeMenuTreeModelEntity.lisenseLink = lisenseLink;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    knowledgeMenuTreeModelEntity.name = name;
  }
  final int? order = jsonConvert.convert<int>(json['order']);
  if (order != null) {
    knowledgeMenuTreeModelEntity.order = order;
  }
  final int? parentChapterId = jsonConvert.convert<int>(
      json['parentChapterId']);
  if (parentChapterId != null) {
    knowledgeMenuTreeModelEntity.parentChapterId = parentChapterId;
  }
  final int? type = jsonConvert.convert<int>(json['type']);
  if (type != null) {
    knowledgeMenuTreeModelEntity.type = type;
  }
  final bool? userControlSetTop = jsonConvert.convert<bool>(
      json['userControlSetTop']);
  if (userControlSetTop != null) {
    knowledgeMenuTreeModelEntity.userControlSetTop = userControlSetTop;
  }
  final int? visible = jsonConvert.convert<int>(json['visible']);
  if (visible != null) {
    knowledgeMenuTreeModelEntity.visible = visible;
  }
  return knowledgeMenuTreeModelEntity;
}

Map<String, dynamic> $KnowledgeMenuTreeModelEntityToJson(
    KnowledgeMenuTreeModelEntity entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['articleList'] = entity.articleList;
  data['author'] = entity.author;
  data['children'] = entity.children?.map((v) => v.toJson()).toList();
  data['courseId'] = entity.courseId;
  data['cover'] = entity.cover;
  data['desc'] = entity.desc;
  data['id'] = entity.id;
  data['lisense'] = entity.lisense;
  data['lisenseLink'] = entity.lisenseLink;
  data['name'] = entity.name;
  data['order'] = entity.order;
  data['parentChapterId'] = entity.parentChapterId;
  data['type'] = entity.type;
  data['userControlSetTop'] = entity.userControlSetTop;
  data['visible'] = entity.visible;
  return data;
}

extension KnowledgeMenuTreeModelEntityExtension on KnowledgeMenuTreeModelEntity {
  KnowledgeMenuTreeModelEntity copyWith({
    List<dynamic>? articleList,
    String? author,
    List<KnowledgeMenuTreeModelEntity>? children,
    int? courseId,
    String? cover,
    String? desc,
    int? id,
    String? lisense,
    String? lisenseLink,
    String? name,
    int? order,
    int? parentChapterId,
    int? type,
    bool? userControlSetTop,
    int? visible,
  }) {
    return KnowledgeMenuTreeModelEntity()
      ..articleList = articleList ?? this.articleList
      ..author = author ?? this.author
      ..children = children ?? this.children
      ..courseId = courseId ?? this.courseId
      ..cover = cover ?? this.cover
      ..desc = desc ?? this.desc
      ..id = id ?? this.id
      ..lisense = lisense ?? this.lisense
      ..lisenseLink = lisenseLink ?? this.lisenseLink
      ..name = name ?? this.name
      ..order = order ?? this.order
      ..parentChapterId = parentChapterId ?? this.parentChapterId
      ..type = type ?? this.type
      ..userControlSetTop = userControlSetTop ?? this.userControlSetTop
      ..visible = visible ?? this.visible;
  }
}