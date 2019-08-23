import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';
import 'package:wan_android_flutter/net/HttpResult.dart';

class HttpManager {

  bool isInit = false;

  Dio _dio = Dio();

  resultError(DioError error){
  }

  Future<HttpResult<T>> request<T>(String url,
      FromJson<T> fromJson,
      [bool isMethodGet = true,
        Map<String,dynamic> formData]) async {

    if(!isInit){
      String tempPath = (await getTemporaryDirectory()).path;
      _dio.interceptors.add(CookieManager(PersistCookieJar(dir: "$tempPath/cookies/")));
      isInit = true;
    }
    print(url);
    print(formData);
    Response response;
    try {
      if(isMethodGet&&formData == null){
        response = await _dio.get(url);
      }else{
        response = await _dio.post(url,data: formData==null?null:FormData.from(formData));
      }
    } on DioError catch (e) {
      print(e);
      return resultError(e);
    }
    if(response.data is DioError) {
      return resultError(response.data);
    }
    HttpResult<T> res = HttpResult<T>.fromJson(response.data,fromJson);
    assert(showLog(response.data));
    return res;
  }

  bool showLog(dynamic res){
    print(res);
    return true;
  }
}

final httpManager = new HttpManager();