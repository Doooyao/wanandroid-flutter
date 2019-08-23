import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';
import 'package:wan_android_flutter/dao/collect_dao.dart';
import 'package:wan_android_flutter/widget/dialogs.dart';
import 'package:wan_android_flutter/widget/home_page_widget.dart';
import 'package:wan_android_flutter/widget/wan_list.dart';

class CollectListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return CollectListPageState();
  }
}

class CollectListPageState extends State<CollectListPage> {

  GlobalKey<WanListWidgetState<HomeArticleBean>> listKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: WanColor.primary,
        title: Text('收藏'),
        actions: <Widget>[
          GestureDetector(
            onTap: _onFabPress,
            child: Container(
              margin: EdgeInsets.only(right: 12),
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
      body: WanListWidget<HomeArticleBean>(
        key: listKey,
        itemBuilder: (context, index, data) => HomeArticleItem(
          data.value,
          onCollectClick: (){
            if(data.value.collect)
              _unCollect(data.value);
          },
        ),
        dataRequest: _requestData,
      ),
    );
  }

  Future<List<HomeArticleBean>> _requestData(int page) async {
    return (await CollectDao.getCollectArticle(page)).data.datas;
  }

  void _onFabPress() {
    showDialog<List<String>>(
      context: context, //BuildContext对象
      barrierDismissible: false,
      builder: (BuildContext context) => AddCollectDialog(),
    ).then((res) {
      if (res != null && res.length == 3) {
        _addCollectUnCheck(res);
      }
    });
  }

  void _addCollectUnCheck(List<String> res) {
    CollectDao.doCollectOuterArticle(res[0], res[1], res[2]).then((res){
      if(res.isSuccess()){
        listKey.currentState?.insert(res.data,index: 0);
      }else{
        ToastUtils.show(msg: res.errorMsg);
      }
    });
  }

  void _unCollect(HomeArticleBean item) {
    CollectDao.unCollectWithCollectId(item.id,item.originId??-1).then((res){
      if(res.isSuccess()){
        listKey.currentState?.remove(item);
      }else{
        ToastUtils.show(msg: res.errorMsg);
      }
    });
  }
}
