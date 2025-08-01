// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'home_list_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeListModel _$HomeListModelFromJson(Map<String, dynamic> json) =>
    HomeListModel()
      ..data = json['data'] == null
          ? null
          : HomeListDatas.fromJson(json['data'] as Map<String, dynamic>)
      ..errorCode = json['errorCode'] as num?
      ..errorMsg = json['errorMsg'] as String?;

Map<String, dynamic> _$HomeListModelToJson(HomeListModel instance) =>
    <String, dynamic>{
      'data': instance.data,
      'errorCode': instance.errorCode,
      'errorMsg': instance.errorMsg,
    };

HomeListDatas _$HomeListDatasFromJson(Map<String, dynamic> json) =>
    HomeListDatas()
      ..curPage = json['curPage'] as num?
      ..datas = (json['datas'] as List<dynamic>?)
          ?.map(HomeListData.fromJson)
          .toList()
      ..offset = json['offset'] as num?
      ..over = json['over'] as bool?
      ..pageCount = json['pageCount'] as num?
      ..size = json['size'] as num?
      ..total = json['total'] as num?;

Map<String, dynamic> _$HomeListDatasToJson(HomeListDatas instance) =>
    <String, dynamic>{
      'curPage': instance.curPage,
      'datas': instance.datas,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total,
    };
