import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/home/home_model.dart';
import 'package:json_annotation/json_annotation.dart';


HomeModel $HomeModelFromJson(Map<String, dynamic> json) {
  final HomeModel homeModel = HomeModel();
  final List<HomeModelData>? data = (json['data'] as List<dynamic>?)
      ?.map(
          (e) => jsonConvert.convert<HomeModelData>(e) as HomeModelData)
      .toList();
  if (data != null) {
    homeModel.data = data;
  }
  final num? errorCode = jsonConvert.convert<num>(json['errorCode']);
  if (errorCode != null) {
    homeModel.errorCode = errorCode;
  }
  final String? errorMsg = jsonConvert.convert<String>(json['errorMsg']);
  if (errorMsg != null) {
    homeModel.errorMsg = errorMsg;
  }
  return homeModel;
}

Map<String, dynamic> $HomeModelToJson(HomeModel entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['data'] = entity.data?.map((v) => v.toJson()).toList();
  data['errorCode'] = entity.errorCode;
  data['errorMsg'] = entity.errorMsg;
  return data;
}

extension HomeModelExtension on HomeModel {
  HomeModel copyWith({
    List<HomeModelData>? data,
    num? errorCode,
    String? errorMsg,
  }) {
    return HomeModel()
      ..data = data ?? this.data
      ..errorCode = errorCode ?? this.errorCode
      ..errorMsg = errorMsg ?? this.errorMsg;
  }
}

HomeModelData $HomeModelDataFromJson(Map<String, dynamic> json) {
  final HomeModelData homeModelData = HomeModelData();
  final String? desc = jsonConvert.convert<String>(json['desc']);
  if (desc != null) {
    homeModelData.desc = desc;
  }
  final num? id = jsonConvert.convert<num>(json['id']);
  if (id != null) {
    homeModelData.id = id;
  }
  final String? imagePath = jsonConvert.convert<String>(json['imagePath']);
  if (imagePath != null) {
    homeModelData.imagePath = imagePath;
  }
  final num? isVisible = jsonConvert.convert<num>(json['isVisible']);
  if (isVisible != null) {
    homeModelData.isVisible = isVisible;
  }
  final num? order = jsonConvert.convert<num>(json['order']);
  if (order != null) {
    homeModelData.order = order;
  }
  final String? title = jsonConvert.convert<String>(json['title']);
  if (title != null) {
    homeModelData.title = title;
  }
  final num? type = jsonConvert.convert<num>(json['type']);
  if (type != null) {
    homeModelData.type = type;
  }
  final String? url = jsonConvert.convert<String>(json['url']);
  if (url != null) {
    homeModelData.url = url;
  }
  return homeModelData;
}

Map<String, dynamic> $HomeModelDataToJson(HomeModelData entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['desc'] = entity.desc;
  data['id'] = entity.id;
  data['imagePath'] = entity.imagePath;
  data['isVisible'] = entity.isVisible;
  data['order'] = entity.order;
  data['title'] = entity.title;
  data['type'] = entity.type;
  data['url'] = entity.url;
  return data;
}

extension HomeModelDataExtension on HomeModelData {
  HomeModelData copyWith({
    String? desc,
    num? id,
    String? imagePath,
    num? isVisible,
    num? order,
    String? title,
    num? type,
    String? url,
  }) {
    return HomeModelData()
      ..desc = desc ?? this.desc
      ..id = id ?? this.id
      ..imagePath = imagePath ?? this.imagePath
      ..isVisible = isVisible ?? this.isVisible
      ..order = order ?? this.order
      ..title = title ?? this.title
      ..type = type ?? this.type
      ..url = url ?? this.url;
  }
}