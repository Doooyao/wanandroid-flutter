import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/bean/TagSystem.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/notifier_utils.dart';
import 'package:wan_android_flutter/dao/collect_dao.dart';
import 'package:wan_android_flutter/dao/home_dao.dart';
import 'package:wan_android_flutter/widget/home_page_widget.dart';
import 'package:wan_android_flutter/widget/system_tag_tab.dart';
import 'package:wan_android_flutter/widget/wan_list.dart';
import 'dart:math';

class SystemContentPage extends StatefulWidget {
  final String tabFirstHeroTag;
  final String tabSecondHeroTag;
  final TagSystem parent;
  final TagSystem child;

  const SystemContentPage(
      {this.parent, this.child, this.tabFirstHeroTag, this.tabSecondHeroTag});

  @override
  State<StatefulWidget> createState() {
    return SystemContentPageState();
  }
}

class SystemContentPageState extends State<SystemContentPage>
    with TickerProviderStateMixin, CollectMixin {
  SystemSelected selectedSystem;
  ScrollController _scrollController;

  GlobalKey<WanListWidgetState> listKey = GlobalKey();

  AnimationController _animCtr;

  double _lastScrolldy = 0;

  @override
  void initState() {
    selectedSystem = SystemSelected();
    selectedSystem.parent = widget.parent;
    selectedSystem.child = widget.child;
    _scrollController = ScrollController();
    _scrollController.addListener(() {
      print(_scrollController.offset);
    });
    _animCtr =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _animCtr.addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: WanColor.primary,
      body: SafeArea(
        child: Container(
          color: Colors.white,
          child: MultiProvider(
            providers: <SingleChildCloneableWidget>[
              ChangeNotifierProvider<SystemSelected>.value(
                  value: selectedSystem),
              ChangeNotifierProvider<SystemTagsHead>.value(
                  value: SystemTagsHead()),
            ],
            child: NotificationListener<ScrollNotification>(
              onNotification: (notify) {
                switch (notify.runtimeType) {
                  case ScrollUpdateNotification:
                    if (notify.metrics.axis == Axis.vertical)
                      _lastScrolldy =
                          (notify as ScrollUpdateNotification).scrollDelta;
                    break;
                  case UserScrollNotification:
                    _stopAnimScrollIfNeed();
                    break;
                  case ScrollEndNotification:
                    if (notify.metrics.axis == Axis.vertical)
                      _startAnimScrollIfNeed();
                    break;
                }
                return false;
              },
              child: Consumer2<ListNotifier<TagSystem>, SystemTagsHead>(
                  builder: (context, data, headDelegate, _) {
                print("max:${headDelegate.maxExtent}");
                return NestedScrollView(
                  controller: _scrollController,
                  headerSliverBuilder: (context, _) => <Widget>[
                    SliverAppBar(
                      backgroundColor: WanColor.primary,
                      title: Text(selectedSystem.parent.name),
                    ),
                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: headDelegate,
                    ),
                  ],
                  body: Column(
                    children: <Widget>[
                      Expanded(
                        child: Consumer<SystemSelected>(
                          builder: (context, _1, _2) {
                            listKey?.currentState?.refreshData(true);
                            return WanListWidget<HomeArticleBean>(
                              key: listKey,
                              itemBuilder: (context, index, data) =>
                                  HomeArticleItem(
                                data.value,
                                onItemPressed: () {
                                  NavigatorUtils.goArticleDetail(
                                    context,
                                    data.value.link,
                                    title: data.value.title,
                                  );
                                },
                                onCollectClick: () =>
                                    onCollectClick(context, data),
                              ),
                              dataRequest: requestData,
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }

  Future<List<HomeArticleBean>> requestData(int page) async =>
      (await HomeDao.getArticlesOfSystem(page, selectedSystem.child.id))
          .data
          .datas;

  void _startAnimScrollIfNeed() {
//    if (_scrollController.offset == 0 || _scrollController.offset == )
  }

  void _stopAnimScrollIfNeed() {
    if (_animCtr.isAnimating) _animCtr.stop();
  }
}

class SystemTagsHead extends SliverPersistentHeaderDelegate
    with ChangeNotifier {
  GlobalKey key = GlobalKey();

  SystemTagsHead();

  bool hasInitialized = false;
  bool waitForRebuild = false;

  double _maxExtent = 1000;
  double _minExtent = 0;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      key: key,
      decoration: BoxDecoration(
        color: WanColor.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey[500],
            offset: Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      child: SystemTagTab(
          maxExtent - minExtent == 0
              ? 1
              : shrinkOffset / (maxExtent - minExtent),
          onPostFrame: (unExpandHeight, expandHeight) {
        if (hasInitialized) return;
        _maxExtent = max(expandHeight, unExpandHeight);
        _minExtent = unExpandHeight;
        hasInitialized = true;
        waitForRebuild = true;
        notifyListeners();
      }),
    );
  }

  @override
  bool operator ==(other) {
    return !waitForRebuild && (hashCode == other.hashCode);
  }

  @override
  double get maxExtent => _maxExtent;

  @override
  double get minExtent => _minExtent;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) {
    waitForRebuild = false;
    print("shoudRebuild");
    return true;
  }
}

class SystemSelected extends ChangeNotifier {
  TagSystem _parent;
  TagSystem _child;

  TagSystem get parent => _parent;

  TagSystem get child => _child;

  set parent(TagSystem tag) {
    _parent = tag;
    notifyListeners();
  }

  set child(TagSystem tag) {
    _child = tag;
    notifyListeners();
  }
}
