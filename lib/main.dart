import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/page/home_page.dart';
import 'package:wan_android_flutter/widget/search_bar_widget.dart';
import 'bean/TagSystem.dart';
import 'bean/UserInfo.dart';
import 'common/style/wan_style.dart';
import 'common/util/notifier_utils.dart';
import 'dao/account_dao.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<SearchQuery>.value(value: SearchQuery('')),//搜索
      ChangeNotifierProvider<ListNotifier<TagSystem>>.value(value: ListNotifier(List())),//搜索
      ChangeNotifierProvider<ValueNotifier<UserInfo>>.value(value: _autoLogin()),//用户账号
    ],
    child: MyApp(),
  ));
}

/// 自动登录
ValueNotifier<UserInfo> _autoLogin() {
  ValueNotifier<UserInfo> userInfo = ValueNotifier(null);
  AccountDao.getAccount().then((account){
    if(account!=null&&account.length == 2)
      AccountDao.signIn(account[0], account[1]).then((res){
        if(res.isSuccess())
          userInfo.value = res.data;
      });
  });
  return userInfo;
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      color: WanColor.primary,
      home: HomePage(),
    );
  }
}
