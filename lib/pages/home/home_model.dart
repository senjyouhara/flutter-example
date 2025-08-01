import 'package:json_annotation/json_annotation.dart';

// 记得要加入这个，这个名字通常都是 '实体类的名字.g.dart'
part 'home_model.g.dart';

@JsonSerializable()
class HomeModel {

  HomeModel();

  List<HomeModelData>? data;
  num? errorCode;
  String? errorMsg;

  // 下面这两个模板方法，就按照官方文档这么定义就好，用来自动生成解析代码
  factory HomeModel.fromJson(Map<String, dynamic> json) =>
      _$HomeModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelToJson(this);
}
// 要加上这个注解
@JsonSerializable()
class HomeModelData {
  String? desc;
  num? id;
  String? imagePath;
  num? isVisible;
  num? order;
  String? title;
  num? type;
  String? url;

  HomeModelData();

  // 下面这两个模板方法，就按照官方文档这么定义就好，用来自动生成解析代码
  factory HomeModelData.fromJson(Map<String, dynamic> json) =>
      _$HomeModelDataFromJson(json);

  Map<String, dynamic> toJson() => _$HomeModelDataToJson(this);
}
