import 'package:flutter/widgets.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastUtils {
  static Future<bool> show({
    @required
    String msg,
    WanToastLength length = WanToastLength.SHORT,
    WanToastGravity gravity = WanToastGravity.BOTTOM,
    Color bgColor,
    Color textColor,
  }) async {
    bgColor??=Color(0x77000000);
    textColor??=Color(0xffffffff);

    bool success = await Fluttertoast.showToast(
        msg: msg,
        toastLength: convertLength(length),
        gravity: convertGravity(gravity),
        timeInSecForIos: 1,
        backgroundColor: bgColor,
        textColor: textColor);
    return success;
  }

  static Toast convertLength(WanToastLength length){
    switch(length){
      case WanToastLength.SHORT:
        return Toast.LENGTH_SHORT;
      case WanToastLength.LONG:
        return Toast.LENGTH_LONG;
    }
    return Toast.LENGTH_SHORT;
  }

  static ToastGravity convertGravity(WanToastGravity gravity){
    switch(gravity){
      case WanToastGravity.BOTTOM:
        return ToastGravity.BOTTOM;
      case WanToastGravity.CENTER:
        return ToastGravity.CENTER;
      case WanToastGravity.TOP:
        return ToastGravity.TOP;
    }
    return ToastGravity.BOTTOM;
  }
}

enum WanToastLength {
  SHORT,
  LONG,
}

enum WanToastGravity { TOP, BOTTOM, CENTER }
