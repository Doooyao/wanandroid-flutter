import 'package:flutter/material.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';

/// Copy from https://www.jianshu.com/p/4bbbb5aa855d author:Cosecant
/// ~~~Coder's Things,no Call STOLE~~~ 嘻嘻
class LoadingDialog extends Dialog {
  final String text;

  LoadingDialog({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      //创建透明层
      type: MaterialType.transparency, //透明类型
      child: Center(
        //保证控件居中效果
        child: SizedBox(
          width: 120.0,
          height: 120.0,
          child: Container(
            decoration: ShapeDecoration(
              color: Color(0xffffffff),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(8.0),
                ),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator(),
                Padding(
                  padding: const EdgeInsets.only(
                    top: 20.0,
                  ),
                  child: Text(
                    text,
                    style: TextStyle(fontSize: 12.0),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AddCollectDialog extends Dialog {

  final TextEditingController _titleCtr = TextEditingController();
  final TextEditingController _userCtr = TextEditingController();
  final TextEditingController _linkCtr = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Material(
          //创建透明层
          type: MaterialType.transparency, //透明类型
          child: Center(
            //保证控件居中效果
            child: Container(
              margin: EdgeInsets.all(16),
              child: Card(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.fromLTRB(16, 12, 0, 4),
                      child: Text(
                        "新增收藏",
                        style: TextStyle(
                          color: WanColor.grey,
                          fontSize: 20,
                        ),
                      ),
                    ),
                    _getInputWidget(Icons.title, "请输入标题*",controller: _titleCtr),
                    _getInputWidget(Icons.person, "请输入作者",controller: _userCtr),
                    _getInputWidget(Icons.link, "请输入链接地址*",controller: _linkCtr),
                    Container(
                      margin: EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: ()=>Navigator.pop(context),
                              child: Container(
                                child: Icon(
                                  Icons.clear,
                                  size: 25,
                                  color: Colors.red,
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: GestureDetector(
                              onTap: (){
                                if(_titleCtr.text.trim() == ""){
                                  ToastUtils.show(msg: "请输入标题");
                                  return;
                                }
                                if(_linkCtr.text.trim() == ""){
                                  ToastUtils.show(msg: "请输入链接");
                                  return;
                                }
                                Navigator.pop(context,<String>[_titleCtr.text,_userCtr.text,_linkCtr.text]);
                              },
                              child: Container(
                                child: Icon(
                                  Icons.check,
                                  size: 25,
                                  color: Colors.green,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getInputWidget(IconData iconData, String hint,
          {TextEditingController controller}) =>
      Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            margin: EdgeInsets.fromLTRB(16, 8, 16, 0),
            child: Row(
              children: <Widget>[
                Container(
                  child: Icon(
                    iconData,
                    size: 20,
                    color: WanColor.grey,
                  ),
                  margin: EdgeInsets.only(right: 8),
                ),
                Expanded(
                  child: TextField(
                    style: TextStyle(
                      fontSize: 14,
                    ),
                    controller: controller,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      hintText: hint,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
            height: 1,
            color: WanColor.grey,
          ),
        ],
      );
}
