import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:wan_android_flutter/bean/HomeArticleList.dart';
import 'package:wan_android_flutter/bean/UserInfo.dart';
import 'package:wan_android_flutter/dao/api.dart';
import 'package:wan_android_flutter/net/HttpResult.dart';
import 'package:wan_android_flutter/net/http_manager.dart';

class AccountDao {
  //登录
  static Future<HttpResult<UserInfo>> signIn(
          String username, String password) async =>
      await httpManager.request(
          Api.signIn(username, password), (json) => UserInfo.fromJson(json),false);

  //注册
  static Future<HttpResult<UserInfo>> signUp(
          String username, String password, String repassword) async =>
      await httpManager.request(Api.signUp(username, password, repassword),
          (json) => UserInfo.fromJson(json),false);

  //退出
  static Future<HttpResult<UserInfo>> signOut() async =>
      await httpManager.request(
          Api.signOut(), (json) => null);



  static Future<void> saveAccount(String account,String password) async{
    File file = await _getTempAccountFile();
    print(file.path);
    file.writeAsStringSync("$account\n$password");
    print(file.readAsStringSync());
    return;
  }

  static Future<List<String>> getAccount() async{
    File file = await _getTempAccountFile();
    List<String> account = file.readAsLinesSync();
    if(account == null||account.length!=2)
      return null;
    return account;
  }

  static Future<void> clearAccount() async{
    File file = await _getTempAccountFile();
    await file.writeAsString('');
    return;
  }

  static String _tempAccountPath;

  static Future<File> _getTempAccountFile() async {
    _tempAccountPath??= "${(await getTemporaryDirectory()).path}/tempSave/account.txt";
    File file = File(_tempAccountPath);
    if(file.existsSync())
      return file;
    file.createSync(recursive: true);
    return file;
  }
}
