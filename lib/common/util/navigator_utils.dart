import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/bean/TagSystem.dart';
import 'package:wan_android_flutter/page/collect_list_page.dart';
import 'package:wan_android_flutter/page/search_result_page.dart';
import 'package:wan_android_flutter/page/sign_in_page.dart';
import 'package:wan_android_flutter/page/system_content_page.dart';
import 'package:wan_android_flutter/page/web_page.dart';

class NavigatorUtils {
  ///文章详情页面
  static Future goArticleDetail(
    BuildContext context,
    String url, {
    String title,
  }) {
    return NavigatorRouter(
        context,
        ArticleWebPage(
          url: url,
          title: title,
        ));
  }

  ///搜索结果页面
  static Future goSearchArticle(BuildContext context) {
    return NavigatorRouter(context, SearchResultPage(),type: AnimType.FADE);
  }

  ///搜索结果页面
  static Future goSignInPage(BuildContext context) {
    return NavigatorRouter(context, SignInPage(),);
  }

  static Future goCollectListPage(BuildContext context){
    return NavigatorRouter(context, CollectListPage());
  }


  ///搜索结果页面
  static Future goSystemContent(
      BuildContext context, TagSystem father, TagSystem child) {
    return NavigatorRouter(
        context,
        SystemContentPage(
          parent: father,
          child: child,
        ));
  }

  ///公共打开方式
  static NavigatorRouter(BuildContext context, Widget widget,{AnimType type = AnimType.SLIDE}) {
    return Navigator.push(context, AnimRouteBuilder(widget,type));
  }

  static pop(BuildContext context){
    Navigator.pop(context);
  }

  ///Page页面的容器，做一次通用自定义
  static Widget pageContainer(widget) {
    return MediaQuery(

        ///不受系统字体缩放影响
        data: MediaQueryData.fromWindow(WidgetsBinding.instance.window)
            .copyWith(textScaleFactor: 1),
        child: widget);
  }
}

enum AnimType {
  FADE,
  ROTATION,
  SLIDE,
}

class AnimRouteBuilder extends PageRouteBuilder {
  final Widget widget;
  final AnimType _animType;

  AnimRouteBuilder(this.widget, [this._animType])
      : super(
            transitionDuration: const Duration(milliseconds: 500), //设置动画时长500毫秒
            pageBuilder: (BuildContext context, Animation<double> animation1,
                Animation<double> animation2) {
              return widget;
            },
            transitionsBuilder: (BuildContext context,
                Animation<double> animation1,
                Animation<double> animation2,
                Widget child) {
              //渐变过渡
              switch (_animType) {
                case AnimType.FADE:
                  return FadeTransition(
                    //渐变过渡 0.0-1.0
                    opacity:
                        Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animation1, //动画样式
                      curve: Curves.fastOutSlowIn, //动画曲线
                    )),
                    child: child,
                  );
                case AnimType.ROTATION:
                  return RotationTransition(
                    turns: Tween(begin: 0.0, end: 1.0).animate(CurvedAnimation(
                      parent: animation1,
                      curve: Curves.fastOutSlowIn,
                    )),
                    child: ScaleTransition(
                      scale: Tween(begin: 0.0, end: 1.0).animate(
                          CurvedAnimation(
                              parent: animation1, curve: Curves.fastOutSlowIn)),
                      child: child,
                    ),
                  );
                case AnimType.SLIDE:
                  return SlideTransition(
                    position: Tween<Offset>(
                            begin: Offset(1.0, 0.0), end: Offset(0.0, 0.0))
                        .animate(CurvedAnimation(
                            parent: animation1, curve: Curves.fastOutSlowIn)),
                    child: child,
                  );
              }
              return null;
            });
}
