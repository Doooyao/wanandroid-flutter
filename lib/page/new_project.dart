import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/common/util/app_utils.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';
import 'package:wan_android_flutter/dao/collect_dao.dart';
import 'package:wan_android_flutter/dao/home_dao.dart';
import 'package:wan_android_flutter/widget/home_page_widget.dart';
import 'package:wan_android_flutter/widget/wan_list.dart';

class NewProject extends StatelessWidget with CollectMixin {
  @override
  Widget build(BuildContext context) {
    return WanListWidget<HomeArticleBean>(
      itemBuilder: (context, index, data) => HomeProjectItem(
        data.value,
        index,
        onItemPressed: () {
          NavigatorUtils.goArticleDetail(context, data.value.link,
              title: data.value.title);
        },
        onCollectClick: () => onCollectClick(context, data),
      ),
      dataRequest: requestData,
    );
  }

  Future<List<HomeArticleBean>> requestData(int page) async =>
      (await HomeDao.getHomeProjectList(page)).data.datas;
}
