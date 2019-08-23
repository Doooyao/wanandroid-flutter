import 'package:flutter/cupertino.dart';

import 'HomeArticleBean.dart';
import 'package:json_annotation/json_annotation.dart';

part 'HomeArticleList.g.dart';

@JsonSerializable()
class HomeArticleList with ChangeNotifier{
  List<HomeArticleBean> datas;
  int curPage;
  int offset;
  bool over;
  int pageCount;
  int size;
  int total;
  HomeArticleList({this.datas,this.curPage,this.offset,this.over,this.pageCount,this.size,this.total});

  factory HomeArticleList.fromJson(Map<String, dynamic> json) =>_$HomeArticleListFromJson(json);
}