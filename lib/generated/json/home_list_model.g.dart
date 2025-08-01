import 'package:example/generated/json/base/json_convert_content.dart';
import 'package:example/pages/home/home_list_model.dart';
import 'package:json_annotation/json_annotation.dart';


HomeListDatas $HomeListDatasFromJson(Map<String, dynamic> json) {
  final HomeListDatas homeListDatas = HomeListDatas();
  final num? curPage = jsonConvert.convert<num>(json['curPage']);
  if (curPage != null) {
    homeListDatas.curPage = curPage;
  }
  final List<HomeListData>? datas = (json['datas'] as List<dynamic>?)?.map(
          (e) => jsonConvert.convert<HomeListData>(e) as HomeListData).toList();
  if (datas != null) {
    homeListDatas.datas = datas;
  }
  final num? offset = jsonConvert.convert<num>(json['offset']);
  if (offset != null) {
    homeListDatas.offset = offset;
  }
  final bool? over = jsonConvert.convert<bool>(json['over']);
  if (over != null) {
    homeListDatas.over = over;
  }
  final num? pageCount = jsonConvert.convert<num>(json['pageCount']);
  if (pageCount != null) {
    homeListDatas.pageCount = pageCount;
  }
  final num? size = jsonConvert.convert<num>(json['size']);
  if (size != null) {
    homeListDatas.size = size;
  }
  final num? total = jsonConvert.convert<num>(json['total']);
  if (total != null) {
    homeListDatas.total = total;
  }
  return homeListDatas;
}

Map<String, dynamic> $HomeListDatasToJson(HomeListDatas entity) {
  final Map<String, dynamic> data = <String, dynamic>{};
  data['curPage'] = entity.curPage;
  data['datas'] = entity.datas?.map((v) => v.toJson()).toList();
  data['offset'] = entity.offset;
  data['over'] = entity.over;
  data['pageCount'] = entity.pageCount;
  data['size'] = entity.size;
  data['total'] = entity.total;
  return data;
}

extension HomeListDatasExtension on HomeListDatas {
  HomeListDatas copyWith({
    num? curPage,
    List<HomeListData>? datas,
    num? offset,
    bool? over,
    num? pageCount,
    num? size,
    num? total,
  }) {
    return HomeListDatas()
      ..curPage = curPage ?? this.curPage
      ..datas = datas ?? this.datas
      ..offset = offset ?? this.offset
      ..over = over ?? this.over
      ..pageCount = pageCount ?? this.pageCount
      ..size = size ?? this.size
      ..total = total ?? this.total;
  }
}