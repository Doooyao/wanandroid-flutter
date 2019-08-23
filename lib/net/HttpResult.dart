class HttpResult<T>{
  int errorCode;
  String errorMsg;
  T data;
  bool isSuccess() => errorCode == 0;

  HttpResult({this.errorCode,this.errorMsg,this.data});

  factory HttpResult.fromJson(Map<String,dynamic> map,FromJson fromJson) => HttpResult<T>(
      errorCode: map['errorCode'],
      errorMsg: map['errorMsg'],
      data: map['data'] == null?null:fromJson(map['data']));
}

typedef T FromJson<T>(dynamic json);
