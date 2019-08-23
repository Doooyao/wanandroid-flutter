import 'package:flutter/material.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/common/util/app_utils.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/notifier_utils.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';
import 'package:wan_android_flutter/dao/collect_dao.dart';
import 'package:wan_android_flutter/dao/home_dao.dart';
import 'package:wan_android_flutter/widget/home_page_widget.dart';
import 'package:wan_android_flutter/widget/wan_list.dart';

class NewArticle extends StatelessWidget with CollectMixin {
  @override
  Widget build(BuildContext context) {
    return WanListWidget<HomeArticleBean>(
      itemBuilder: (context, index, data) => HomeArticleItem(
        data.value,
        onItemPressed: () {
          NavigatorUtils.goArticleDetail(
            context,
            data.value.link,
            title: data.value.title,
          );
        },
        onCollectClick: () => onCollectClick(context, data),
      ),
      dataRequest: requestData,
    );
  }

  Future<List<HomeArticleBean>> requestData(int page) async {
    List<HomeArticleBean> _data = List();
    if (page == 0) _data.addAll((await HomeDao.getHomeTopArticleList()).data);
    _data.addAll((await HomeDao.getHomeArticleList(page)).data.datas);
    return _data;
  }
}
