import 'ArticleTag.dart';
import 'package:json_annotation/json_annotation.dart';

import 'UserInfo.dart';

part 'HomeArticleBean.g.dart';

@JsonSerializable()
class HomeArticleBean {
  String apkLink;
  String author;
  int chapterId;
  String chapterName;
  bool collect; //是否收藏了
  int courseId;
  String desc;
  String envelopePic;
  bool fresh;
  int id;
  String link;
  String niceDate;
  String origin;
  String prefix;
  String projectLink;
  int publishTime;
  int superChapterId;
  String superChapterName;
  List<ArticleTag> tags;
  String title;
  int type;
  int userId;
  int visible;
  int zan;
  int originId;

  HomeArticleBean({
    this.apkLink,
    this.author,
    this.chapterId,
    this.chapterName,
    this.collect,
    this.courseId,
    this.desc,
    this.envelopePic,
    this.fresh,
    this.id,
    this.link,
    this.niceDate,
    this.origin,
    this.prefix,
    this.projectLink,
    this.publishTime,
    this.superChapterId,
    this.superChapterName,
    this.tags,
    this.title,
    this.type,
    this.userId,
    this.visible,
    this.zan,
    this.originId,
  });

  factory HomeArticleBean.fromJson(Map<String, dynamic> json) {
    HomeArticleBean res = _$HomeArticleBeanFromJson(json);
    if (res?.fresh??false) res.tags.insert(0, ArticleTag(name: '新'));
    return res;
  }
}
