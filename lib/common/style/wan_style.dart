import 'package:flutter/material.dart';

class WanColor{
  static const titleColor = 0xff222222;

  static const white = Color(0xffffffff);
  static const black = Color(0xff000000);
  static const light_grey = Color(0xffcccccc);
  static const grey = Color(0xff666666);

  static const dark_transparent = Color(0x55000000);

//  static const primary = Colors.lightBlue;
  static const primary = Color(0xff1e5b89);
  static const primaryLight = Color(0xff4f8eac);
}

class WanSize{
  static const lagerTextSize = 30.0;
  static const bigTextSize = 23.0;
  static const normalTextSize = 18.0;
  static const middleTextSize = 16.0;
  static const smallTextSize = 14.0;
  static const minTextSize = 12.0;
}

class WanStyle{

  static const homeArticleTitle = TextStyle(
    color: Color(WanColor.titleColor),
    fontSize: WanSize.smallTextSize,
//    fontWeight: FontWeight.w600,
  );

  static const simpleButtonText = TextStyle(
    color: Color(WanColor.titleColor),
    fontSize: WanSize.minTextSize,
//    fontWeight: FontWeight.w600,
  );
  static const lightMiddleText = TextStyle(
    color: WanColor.grey,
    fontSize: WanSize.smallTextSize,
//    fontWeight: FontWeight.w600,
  );
  static const homeProjectTitle = TextStyle(
    color: Colors.black,
    fontSize: WanSize.normalTextSize,
  );
  static const homeProjectDesc = TextStyle(
    color: WanColor.light_grey,
    fontSize: WanSize.smallTextSize,
  );

  static const searchQuery = TextStyle(
    color: Colors.black87,
    fontSize: WanSize.smallTextSize,
  );
}

class WanIcon{
  static const String FONT_FAMILY = 'wanIconFont';
  static const IconData author = const IconData(0xe602,fontFamily: FONT_FAMILY);
  static const IconData clock = const IconData(0xe64c,fontFamily: FONT_FAMILY);
}