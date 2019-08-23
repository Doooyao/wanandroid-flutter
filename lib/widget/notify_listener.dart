import 'package:flutter/cupertino.dart';

class OnPostFrameListener extends StatelessWidget{

  final VoidCallback onPost;

  final Widget child;

  OnPostFrameListener({this.onPost,@required this.child});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((callback) {
      //初始化数据
      onPost?.call();
    });
    return child;
  }
}