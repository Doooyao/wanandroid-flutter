import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/UserInfo.dart';

import 'navigator_utils.dart';

class AppUtils {

  /// 检查登录
  static checkLogin(BuildContext context,void Function() value){
    UserInfo userInfo = Provider.of<ValueNotifier<UserInfo>>(context).value;
    if(userInfo == null){
      NavigatorUtils.goSignInPage(context).then((_){
        if(userInfo!=null)
          value();
      });
    }else{
      value();
    }
  }
}