import 'package:json_annotation/json_annotation.dart';

part 'HotQuery.g.dart';

@JsonSerializable()
class HotQuery{
  int id;
  String name;
  int link;
  int order;
  int visible;

  HotQuery({this.id,this.name,this.link,this.order,this.visible});

  static fromJson(json) =>_$HotQueryFromJson(json);
}