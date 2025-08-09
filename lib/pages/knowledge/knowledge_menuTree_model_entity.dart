import 'package:example/generated/json/base/json_field.dart';
import 'package:example/generated/json/knowledge_menuTree_model_entity.g.dart';
import 'dart:convert';
export 'package:example/generated/json/knowledge_menuTree_model_entity.g.dart';

@JsonSerializable()
class KnowledgeMenuTreeModelEntity {
	List<dynamic>? articleList;
	String? author;
	List<KnowledgeMenuTreeModelEntity>? children;
	int? courseId;
	String? cover;
	String? desc;
	int? id;
	String? lisense;
	String? lisenseLink;
	String? name;
	int? order;
	int? parentChapterId;
	int? type;
	bool? userControlSetTop;
	int? visible;

	KnowledgeMenuTreeModelEntity();

	factory KnowledgeMenuTreeModelEntity.fromJson(Map<String, dynamic> json) => $KnowledgeMenuTreeModelEntityFromJson(json);

	Map<String, dynamic> toJson() => $KnowledgeMenuTreeModelEntityToJson(this);

	@override
	String toString() {
		return jsonEncode(this);
	}
}