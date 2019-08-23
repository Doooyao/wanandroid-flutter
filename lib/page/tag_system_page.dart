import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/TagSystem.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/notifier_utils.dart';
import 'package:wan_android_flutter/dao/home_dao.dart';
import 'package:wan_android_flutter/widget/home_page_widget.dart';
import 'package:wan_android_flutter/widget/wan_list.dart';

class TagSystemPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Consumer<ListNotifier<TagSystem>>(
      builder: (context,data,_)=>WanListWidget<TagSystem>(
        dataContainer: data,
        itemBuilder: (context,index,data)=>
            TagSystemItem.homePageItem(data.value,onTagClick :(fatherTag,childTag){
              NavigatorUtils.goSystemContent(context, fatherTag, childTag);
            }),
        dataRequest: requestData,
      ),
    );
  }

  Future<List<TagSystem>> requestData(int page) async {
    if(page==0)
      return (await HomeDao.getTagSystemTree()).data;
    return List();
  }
}
