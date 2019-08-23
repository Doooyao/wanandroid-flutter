import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/UserInfo.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';
import 'package:wan_android_flutter/dao/account_dao.dart';
import 'package:wan_android_flutter/widget/custom_widget.dart';

///登录注册页面
class SignInPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SignInPageState();
  }
}

enum SignState {
  SIGN_IN, //登录
  SIGN_UP, //注册
}

class SignInPageState extends State<SignInPage> {
  TextEditingController _userNameEditCtr;
  TextEditingController _passwordEditCtr;
  TextEditingController _rePasswordEditCtr;

  @override
  void initState() {
    _userNameEditCtr = TextEditingController();
    _passwordEditCtr = TextEditingController();
    _rePasswordEditCtr = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<ValueNotifier<SignState>>.value(
      value: ValueNotifier(SignState.SIGN_IN),
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        backgroundColor: WanColor.white,
        body: Consumer<ValueNotifier<SignState>>(
          builder: (context, value, _) => Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  padding: EdgeInsets.fromLTRB(80, 0, 80, 100),
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Image.asset(
                        'images/logo.png',
                        width: 150,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.person,
                                size: 30,
                                color: WanColor.primary,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _userNameEditCtr,
                                maxLines: 1,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '账号',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: WanColor.primary,
                        height: 1,
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.lock,
                                size: 30,
                                color: WanColor.primary,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _passwordEditCtr,
                                maxLines: 1,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '密码',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        color: WanColor.primary,
                        height: 1,
                      ),

                      Container(
                        margin: value.value == SignState.SIGN_IN?null:EdgeInsets.only(top: 20),
                        child: value.value == SignState.SIGN_IN?null:Row(
                          children: <Widget>[
                            Container(
                              margin: EdgeInsets.only(right: 10),
                              child: Icon(
                                Icons.lock,
                                size: 30,
                                color: WanColor.primary,
                              ),
                            ),
                            Expanded(
                              child: TextField(
                                controller: _rePasswordEditCtr,
                                maxLines: 1,
                                obscureText: true,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '再次输入密码',
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        color: WanColor.primary,
                        height: value.value == SignState.SIGN_IN?0:1,
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 50),
                        child: Center(
                          child: new Material(
                            child: new Ink(
                              decoration: new BoxDecoration(
                                color: WanColor.primaryLight,
                                borderRadius: new BorderRadius.all(
                                    new Radius.circular(9.0)),
                              ),
                              child: new InkWell(
                                borderRadius: new BorderRadius.circular(9.0),
                                onTap: () => value.value == SignState.SIGN_IN
                                    ? _signIn(context)
                                    : _signUp(context),
                                child: new Container(
                                  height: 45.0,
                                  alignment: Alignment(0, 0),
                                  child: Text(
                                    value.value == SignState.SIGN_IN
                                        ? "登录"
                                        : "注册",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 16.0),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              GestureDetector(
                onTap: () {
                  value.value = value.value == SignState.SIGN_IN
                      ? SignState.SIGN_UP
                      : SignState.SIGN_IN;
                },
                child: Container(
                  child: Text(
                    value.value == SignState.SIGN_IN
                        ? "～没有账号？点我注册～"
                        : "～已有账号，点我登录～",
                    style: TextStyle(
                      color: Colors.black87,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  margin: EdgeInsets.only(bottom: 30),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 登录
  void _signIn(BuildContext context) {
    AccountDao.signIn(_userNameEditCtr.text, _passwordEditCtr.text)
        .then((result) {
      if (result.isSuccess()) {
        AccountDao.saveAccount(_userNameEditCtr.text, _passwordEditCtr.text);
        ToastUtils.show(msg: "～登录成功～欢迎光临～");
        Provider.of<ValueNotifier<UserInfo>>(context).value = result.data;
        NavigatorUtils.pop(context);
      } else {
        ToastUtils.show(msg: result.errorMsg);
      }
    });
  }

  ///注册
  void _signUp(BuildContext context) {
    AccountDao.signUp(_userNameEditCtr.text, _passwordEditCtr.text,
            _rePasswordEditCtr.text)
        .then((result) {
      if (result.isSuccess()) {
        AccountDao.saveAccount(_userNameEditCtr.text, _passwordEditCtr.text);
        ToastUtils.show(msg: "～注册成功～欢迎光临～");
        Provider.of<ValueNotifier<UserInfo>>(context).value = result.data;
        NavigatorUtils.pop(context);
      } else {
        ToastUtils.show(msg: result.errorMsg);
      }
    });
  }

  @override
  void dispose() {
    _userNameEditCtr.dispose();
    _passwordEditCtr.dispose();
    _rePasswordEditCtr.dispose();
    super.dispose();
  }
}
