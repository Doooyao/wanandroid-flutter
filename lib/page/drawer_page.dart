import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/UserInfo.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/app_utils.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/dao/account_dao.dart';
import 'package:wan_android_flutter/widget/custom_widget.dart';

class DrawerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<ValueNotifier<UserInfo>>(
      builder: (context, userInfo, _) => Column(
        children: <Widget>[
          Container(
            height: 200,
            color: WanColor.primary,
            child: Container(
              margin: EdgeInsets.all(12),
              alignment: Alignment.bottomLeft,
              child: GestureDetector(
                onTap: () {
                  if (userInfo.value == null)
                    NavigatorUtils.goSignInPage(context);
                },
                child: Text(
                  userInfo.value == null ? '未登录,点击登录' : userInfo.value.username,
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.all(12),
            child:           Row(
              children: <Widget>[
                GestureDetector(
                  onTap: () => _gotoColllectList(context),
                  child: IconText(
                    IconText.topIcon,
                    Icons.star,
                    Text("收藏",
                      style: TextStyle(
                        color: WanColor.grey,
                        fontSize: 14,
                      ),
                    ),oversize: 16,iconPadding: 4,),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () {
              if (userInfo.value != null) {
                _signout(context);
              }
            },
            child: Container(
              child: userInfo.value == null ? null : Text("退出账号"),
            ),
          ),
        ],
      ),
    );
  }

  void _signout(BuildContext context) {
    Provider.of<ValueNotifier<UserInfo>>(context).value = null;
    AccountDao.signOut();
    AccountDao.clearAccount();
  }

  void _gotoColllectList(BuildContext context) {
    AppUtils.checkLogin(context, (){
        NavigatorUtils.goCollectListPage(context);
    });
  }
}
