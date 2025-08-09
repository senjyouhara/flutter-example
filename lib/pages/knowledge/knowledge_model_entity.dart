import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/knowledge_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/knowledge_model_entity.g.dart';

@JsonSerializable()
class KnowledgeModelEntity {
	int? curPage;
	List<KnowledgeModelDatas>? datas;
	int? offset;
	bool? over;
	int? pageCount;
	int? size;
	int? total;

	KnowledgeModelEntity();

	factory KnowledgeModelEntity.fromJson(Map<String, dynamic> json) => $KnowledgeModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $KnowledgeModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}

@JsonSerializable()
class KnowledgeModelDatas {
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
	List<dynamic>? tags;
	String? title;
	int? type;
	int? userId;
	int? visible;
	int? zan;

	KnowledgeModelDatas();

	factory KnowledgeModelDatas.fromJson(Map<String, dynamic> json) => $KnowledgeModelDatasFromJson(json);

	Map<String, dynamic> toJson() => $KnowledgeModelDatasToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}