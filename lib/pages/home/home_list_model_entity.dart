import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/home_list_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/home_list_model_entity.g.dart';

@JsonSerializable()
class HomeListModelEntity {
	int? curPage;
	List<HomeListModelDatas>? datas;
	int? offset;
	bool? over;
	int? pageCount;
	int? size;
	int? total;

	HomeListModelEntity();

	factory HomeListModelEntity.fromJson(Map<String, dynamic> json) => $HomeListModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $HomeListModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeListModelDatas {
	bool? adminAdd;
	String? apkLink;
	int? audit;
	String? author;
	bool? canEdit;
	int? chapterId;
	String? chapterName;
	bool? collect;
	int? courseId;
	String? desc;
	String? descMd;
	String? envelopePic;
	bool? fresh;
	String? host;
	int? id;
	bool? isAdminAdd;
	String? link;
	String? niceDate;
	String? niceShareDate;
	String? origin;
	String? prefix;
	String? projectLink;
	int? publishTime;
	int? realSuperChapterId;
	int? selfVisible;
	int? shareDate;
	String? shareUser;
	int? superChapterId;
	String? superChapterName;
	List<HomeListModelDatasTags>? tags;
	String? title;
	int? type;
	int? userId;
	int? visible;
	int? zan;

	HomeListModelDatas();

	factory HomeListModelDatas.fromJson(Map<String, dynamic> json) => $HomeListModelDatasFromJson(json);

	Map<String, dynamic> toJson() => $HomeListModelDatasToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class HomeListModelDatasTags {
	String? name;
	String? url;

	HomeListModelDatasTags();

	factory HomeListModelDatasTags.fromJson(Map<String, dynamic> json) => $HomeListModelDatasTagsFromJson(json);

	Map<String, dynamic> toJson() => $HomeListModelDatasTagsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}