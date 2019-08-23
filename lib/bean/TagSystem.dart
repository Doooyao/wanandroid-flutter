import 'package:json_annotation/json_annotation.dart';

part 'TagSystem.g.dart';

@JsonSerializable()
class TagSystem{
  List<TagSystem> children;
  int courseId;
  int id;
  String name;
  int order;
  int parentChapterId;
  bool userControlSetTop;
  int visible;

  TagSystem({this.children,this.courseId,this.id,this.name,this.order,this.parentChapterId,this.userControlSetTop,this.visible});

  factory TagSystem.fromJson(Map<String, dynamic> json) =>_$TagSystemFromJson(json);
}