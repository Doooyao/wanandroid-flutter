import 'package:json_annotation/json_annotation.dart';

part 'ArticleTag.g.dart';

@JsonSerializable()
class ArticleTag{
  String name;
  String url;

  ArticleTag({
    this.name,
    this.url,
  });

  factory ArticleTag.fromJson(Map<String, dynamic> json) => _$ArticleTagFromJson(json);

  static project(List<ArticleTag> tags){
    for(ArticleTag tag in tags){
      if(tag.name == '项目')
        return true;
    }
    return false;
  }

}