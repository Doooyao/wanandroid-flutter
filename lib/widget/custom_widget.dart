import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';

class OnlyStateBar extends StatelessWidget implements PreferredSizeWidget{

  final Color _color = WanColor.primary;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _color,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

//图标+文字
class IconText extends StatelessWidget{

  static const int startIcon = 0;
  static const int endIcon = 1;
  static const int topIcon = 2;
  static const int bottomIcon = 3;

  int _direction;
  IconData _icon;
  Text _text;
  double size;
  double oversize;
  double iconPadding;

  IconText(
      this._direction,
      this._icon,
      this._text,
        {
          this.size,
          this.oversize = 2,
          this.iconPadding = 0,
        }
      );

  @override
  Widget build(BuildContext context) {
    size??=_text?.style?.fontSize??15;
    switch(_direction){
      case startIcon:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(_icon,size: size+oversize,color: _text?.style?.color,),
            Container(
              margin: EdgeInsets.only(left: iconPadding),
              child: _text,
            ),
          ],
        );
      case endIcon:
        return Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(right: iconPadding),
              child: _text,
            ),
            Icon(_icon,size: size+oversize,color: _text?.style?.color),
          ],
        );
      case topIcon:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Icon(_icon,size: size+oversize,color: _text?.style?.color),
            Container(
              margin: EdgeInsets.only(top: iconPadding),
              child: _text,
            ),
          ],
        );
      case bottomIcon:
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              margin: EdgeInsets.only(bottom: iconPadding),
              child: _text,
            ),
            Icon(_icon,size: size+oversize,color: _text?.style?.color),
          ],
        );
    }
    return null;
  }

}

//Tag标签
class WanTag extends StatelessWidget{

  Color color;
  final String text;
  final VoidCallback onTagPressed;
  WanTag(this.text,{this.color,this.onTagPressed}){
    color??=_getTagColor(text);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: color),
      ),
      child: Container(
        margin: EdgeInsets.fromLTRB(6, 0, 6, 1),
        child: Text(
          text,
          style: TextStyle(
            color: color,
            fontSize: WanSize.minTextSize,
          ),
        ),
      ),
    );
  }

  _getTagColor(String text) {
    switch(text){
      case '置顶':
        return Colors.red;
      case '新':
        return Colors.orange;
      case '问答':
        return Colors.green;
      default:
        return Colors.blue;
    }
  }
}


