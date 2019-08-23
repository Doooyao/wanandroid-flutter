import 'package:flutter/cupertino.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/bean/HomeArticleList.dart';
import 'package:wan_android_flutter/common/util/app_utils.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';
import 'package:wan_android_flutter/net/HttpResult.dart';
import 'package:wan_android_flutter/net/http_manager.dart';

import 'api.dart';

class CollectDao{

  //通过文章id取消收藏
  static Future<HttpResult> unCollectWithArticleId(int articleId) async =>
      await httpManager
          .request(Api.unCollectWithArticleId(articleId),(json)=>null,false);

  //通过文章id添加收藏
  static Future<HttpResult> doCollectWithArticleId(int articleId) async =>
      await httpManager
          .request(Api.doCollectInnerArticle(articleId),(json)=>null,false);

  //获取收藏列表
  static Future<HttpResult<HomeArticleList>> getCollectArticle(int page) async =>
      await httpManager
          .request(Api.getCollectArticle(page), (json)=>
        HomeArticleList.fromJson(json)
            ..datas.forEach((e)=>e.collect = true),
      );

  //收藏外部文章
  static Future<HttpResult<HomeArticleBean>> doCollectOuterArticle(String title,String author,String url) async =>
      await httpManager
      .request(Api.doCollectOuterArticle(title, author, url), (json)=>HomeArticleBean.fromJson(json)..collect = true,false);

  //根据收藏id取消收藏
  static Future<HttpResult> unCollectWithCollectId(int collectId,int originId) async =>
      await httpManager
          .request(Api.unCollectWithCollectId(collectId),(json)=>null,false,Map()..['originId']=originId);
}

mixin CollectMixin{

  void onCollectClick(BuildContext context,ValueNotifier<HomeArticleBean> data){
    AppUtils.checkLogin(
      context,
          () {
        if (data.value.collect) {
          CollectDao.unCollectWithArticleId(data.value.id).then(
                (res) {
              if (res.isSuccess()) {
                data.value.collect = false;
                data.notifyListeners();
              } else {
                ToastUtils.show(msg: res.errorMsg);
              }
            },
          );
        } else {
          CollectDao.doCollectWithArticleId(data.value.id).then((res) {
            if (res.isSuccess()) {
              data.value.collect = true;
              data.notifyListeners();
            } else {
              ToastUtils.show(msg: res.errorMsg);
            }
          });
        }
      },
    );
  }
}