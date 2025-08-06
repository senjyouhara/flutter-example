import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/search_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/search_model_entity.g.dart';

@JsonSerializable()
class SearchModelEntity {
	int? curPage;
	List<SearchModelDatas>? datas;
	int? offset;
	bool? over;
	int? pageCount;
	int? size;
	int? total;

	SearchModelEntity();

	factory SearchModelEntity.fromJson(Map<String, dynamic> json) => $SearchModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $SearchModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchModelDatas {
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
	List<SearchModelDatasTags>? tags;
	String? title;
	int? type;
	int? userId;
	int? visible;
	int? zan;

	SearchModelDatas();

	factory SearchModelDatas.fromJson(Map<String, dynamic> json) => $SearchModelDatasFromJson(json);

	Map<String, dynamic> toJson() => $SearchModelDatasToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class SearchModelDatasTags {
	String? name;
	String? url;

	SearchModelDatasTags();

	factory SearchModelDatasTags.fromJson(Map<String, dynamic> json) => $SearchModelDatasTagsFromJson(json);

	Map<String, dynamic> toJson() => $SearchModelDatasTagsToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}