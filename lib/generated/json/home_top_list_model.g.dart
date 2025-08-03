import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/home/home_top_list_model.dart';
import 'package:json_annotation/json_annotation.dart';


HomeTopListModel $HomeTopListModelFromJson(Map<String, dynamic> json) {
  final HomeTopListModel homeTopListModel = HomeTopListModel();
  final List<dynamic>? articleList = (json['articleList'] as List<dynamic>?)
      ?.map(
          (e) => e)
      .toList();
  if (articleList != null) {
    homeTopListModel.articleList = articleList;
  }
  final String? author = jsonConvert.convert<String>(json['author']);
  if (author != null) {
    homeTopListModel.author = author;
  }
  final List<HomeTopListModel>? children = (json['children'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<HomeTopListModel>(e) as HomeTopListModel)
      .toList();
  if (children != null) {
    homeTopListModel.children = children;
  }
  final num? courseId = jsonConvert.convert<num>(json['courseId']);
  if (courseId != null) {
    homeTopListModel.courseId = courseId;
  }
  final String? cover = jsonConvert.convert<String>(json['cover']);
  if (cover != null) {
    homeTopListModel.cover = cover;
  }
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    homeTopListModel.desc = desc;
  }
  final num? id = jsonConvert.convert<num>(json['id']);
  if (id != null) {
    homeTopListModel.id = id;
  }
  final String? lisense = jsonConvert.convert<String>(json['lisense']);
  if (lisense != null) {
    homeTopListModel.lisense = lisense;
  }
  final String? lisenseLink = jsonConvert.convert<String>(json['lisenseLink']);
  if (lisenseLink != null) {
    homeTopListModel.lisenseLink = lisenseLink;
  }
  final String? name = jsonConvert.convert<String>(json['name']);
  if (name != null) {
    homeTopListModel.name = name;
  }
  final num? order = jsonConvert.convert<num>(json['order']);
  if (order != null) {
    homeTopListModel.order = order;
  }
  final num? parentChapterId = jsonConvert.convert<num>(
      json['parentChapterId']);
  if (parentChapterId != null) {
    homeTopListModel.parentChapterId = parentChapterId;
  }
  final num? type = jsonConvert.convert<num>(json['type']);
  if (type != null) {
    homeTopListModel.type = type;
  }
  final bool? userControlSetTop = jsonConvert.convert<bool>(
      json['userControlSetTop']);
  if (userControlSetTop != null) {
    homeTopListModel.userControlSetTop = userControlSetTop;
  }
  final num? visible = jsonConvert.convert<num>(json['visible']);
  if (visible != null) {
    homeTopListModel.visible = visible;
  }
  return homeTopListModel;
}

Map<String, dynamic> $HomeTopListModelToJson(HomeTopListModel entity) {
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

extension HomeTopListModelExtension on HomeTopListModel {
  HomeTopListModel copyWith({
    List<dynamic>? articleList,
    String? author,
    List<HomeTopListModel>? children,
    num? courseId,
    String? cover,
    String? desc,
    num? id,
    String? lisense,
    String? lisenseLink,
    String? name,
    num? order,
    num? parentChapterId,
    num? type,
    bool? userControlSetTop,
    num? visible,
  }) {
    return HomeTopListModel()
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