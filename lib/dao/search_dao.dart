import 'package:wan_android_flutter/bean/HomeArticleList.dart';
import 'package:wan_android_flutter/bean/HotQuery.dart';
import 'package:wan_android_flutter/dao/api.dart';
import 'package:wan_android_flutter/net/HttpResult.dart';
import 'package:wan_android_flutter/net/http_manager.dart';

class SearchDao{

  //获取搜索热词
  static Future<HttpResult<List<HotQuery>>> getSearchHotQuery() async =>
      await httpManager
          .request(Api.getSearchHotQuery(),(json)=>
        (json as List).map((e)=>HotQuery.fromJson(json)).toList());

  //获取搜索热词
  static Future<HttpResult<HomeArticleList>> doSearch(page,query) async =>
      await httpManager
          .request(Api.doSearch(page, query),(json)=>HomeArticleList.fromJson(json),false);
}