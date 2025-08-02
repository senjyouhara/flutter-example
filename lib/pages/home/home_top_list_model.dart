import 'package:json_annotation/json_annotation.dart';

// 记得要加入这个，这个名字通常都是 '实体类的名字.g.dart'
part 'home_top_list_model.g.dart';

@JsonSerializable()
class HomeTopListModel {
  HomeTopListModel();

  List<dynamic>? articleList;
  String? author;
  List<HomeTopListModel>? children;
  num? courseId;
  String? cover;
  String? desc;
  num? id;
  String? lisense;
  String? lisenseLink;
  String? name;
  num? order;
  num? parentChapterId;
  num? type;
  bool? userControlSetTop;
  num? visible;

  // 下面这两个模板方法，就按照官方文档这么定义就好，用来自动生成解析代码
  factory HomeTopListModel.fromJson(Map<String, dynamic> json) =>
      _$HomeTopListModelFromJson(json);

  Map<String, dynamic> toJson() => _$HomeTopListModelToJson(this);
}
