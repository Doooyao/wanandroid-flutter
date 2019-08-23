import 'package:wan_android_flutter/bean/ArticleTag.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/bean/HomeArticleList.dart';
import 'package:wan_android_flutter/bean/TagSystem.dart';
import 'package:wan_android_flutter/net/HttpResult.dart';
import 'package:wan_android_flutter/net/http_manager.dart';

import 'api.dart';

class HomeDao{

  //获取首页文章列表
  static Future<HttpResult<HomeArticleList>> getHomeArticleList(int page) async =>
      await httpManager
          .request(Api.homeArticleList(page),(json)=>HomeArticleList.fromJson(json));

  //获取首页置顶文章列表
  static Future<HttpResult<List<HomeArticleBean>>> getHomeTopArticleList() async =>
      await httpManager
          .request(Api.homeTopArticleList(), (json){
            return (json as List)
                ?.map((e) => e==null?
                null:HomeArticleBean.fromJson(e)
                  ..tags.insert(0,ArticleTag(name: '置顶')))
                ?.toList();
      });

  //获取首页项目列表
  static Future<HttpResult<HomeArticleList>> getHomeProjectList(int page) async =>
      await httpManager
      .request(Api.homeProjectList(page), (json)=>HomeArticleList.fromJson(json));

  //获取首页体系标签树
  static Future<HttpResult<List<TagSystem>>> getTagSystemTree() async =>
      await httpManager
      .request(Api.getTagSystem(), (json){
        return (json as List)
            ?.map((e) => e==null?
        null:TagSystem.fromJson(e))
            ?.toList();
      });

  static Future<HttpResult<HomeArticleList>> getArticlesOfSystem(int page,int systemId) async =>
      await httpManager.request(Api.articlesOfSystem(page, systemId), (json)=>HomeArticleList.fromJson(json));
}