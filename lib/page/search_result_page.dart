import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/app_utils.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/toast_utils.dart';
import 'package:wan_android_flutter/dao/collect_dao.dart';
import 'package:wan_android_flutter/dao/search_dao.dart';
import 'package:wan_android_flutter/widget/home_page_widget.dart';
import 'package:wan_android_flutter/widget/like_material_bar_widget.dart';
import 'package:wan_android_flutter/widget/search_bar_widget.dart';
import 'package:wan_android_flutter/widget/wan_list.dart';

class SearchResultPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchResultPageState();
  }
}

class SearchResultPageState extends State<SearchResultPage> with CollectMixin {
  GlobalKey<WanListWidgetState> key = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: WanColor.primary,
      child: SafeArea(
        child: SafeArea(
          child: Scaffold(
            body: LikeMaterialBarGroup(
              color: WanColor.white,
              head: LikeMaterialBar(
                hide: Hero(
                  tag: 'search',
                  child: SearchBarWidget(),
                ),
              ),
              body: Consumer<SearchQuery>(
                builder: (context, data, _) {
                  key.currentState?.refreshData(true);
                  return WanListWidget<HomeArticleBean>(
                    key: key,
                    itemBuilder: (context, index, data) => Card(
                      margin:
                          EdgeInsets.fromLTRB(12, index == 0 ? 8 : 1, 12, 0),
                      shape: RoundedRectangleBorder(
                          borderRadius: index == 0
                              ? BorderRadius.vertical(top: Radius.circular(3))
                              : BorderRadius.circular(0)),
                      child: HomeArticleItem(
                        data.value,
                        onItemPressed:() {
                          NavigatorUtils.goArticleDetail(
                              context, data.value.link);
                        },
                        onCollectClick: () => onCollectClick(context, data),
                      ),
                    ),
                    dataRequest: requestData,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<HomeArticleBean>> requestData(int page) async =>
      (await SearchDao.doSearch(page, Provider.of<SearchQuery>(context).value))
          .data
          .datas;
}
