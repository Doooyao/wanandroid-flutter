import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/UserInfo.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/page/tag_system_page.dart';
import 'package:wan_android_flutter/widget/center_primary_controller.dart';
import 'package:wan_android_flutter/widget/like_material_bar_widget.dart';
import 'package:wan_android_flutter/widget/search_bar_widget.dart';

import 'drawer_page.dart';
import 'new_article.dart';
import 'new_project.dart';

class HomePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  TabController _tabController;

  List<GlobalKey<PrimaryScrollContainerState>> scrollChildKeys =
      List.generate(3, (index) => GlobalKey());

  @override
  void initState() {
    _tabController = TabController(length: 3, vsync: this);
    _tabController.addListener(() {
      for (int i = 0; i < scrollChildKeys.length; i++) {
        GlobalKey<PrimaryScrollContainerState> key = scrollChildKeys[i];
        if (key.currentState != null) {
          key.currentState.onPageChange(_tabController.index == i);
        }
      }
    });
    super.initState();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      drawer: new Drawer(
        //New added
        child: DrawerPage(), //New added
      ), //New added
      body: Container(
        color: WanColor.primary,
        child: SafeArea(
          child: Container(
            color: WanColor.light_grey,
            child: LikeMaterialBarGroup(
              head: LikeMaterialBar(
                hide: _getSearchBar(),
                adsorb: _getTabBar(),
                decoration: BoxDecoration(
                  color: WanColor.primary,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey[500],
                      offset: Offset(3, 3),
                      blurRadius: 3,
                    ),
                  ],
                ),
              ),
              body: TabBarView(
                children: <Widget>[
                  PrimaryScrollContainer(
                    scrollChildKeys[0],
                    NewArticle(),
                  ),
                  PrimaryScrollContainer(
                    scrollChildKeys[1],
                    NewProject(),
                  ),
                  PrimaryScrollContainer(
                    scrollChildKeys[2],
                    TagSystemPage(),
                  ),
                ],
                controller: _tabController,
              ),
            ),
          ),
        ),
      ), //通过ConstrainedBox来确保Stack占满屏幕
    );
  }

  Widget _getSearchBar() => Container(
        child: Hero(
          tag: 'search',
          child: SearchBarWidget(),
        ),
      );

  Widget _getTabBar() => Container(
        height: 40,
        child: TabBar(
          tabs: _getTagBarWidgets()
              .map((text) => Container(
                    child: text,
                  ))
              .toList(),
          controller: _tabController,
          indicatorWeight: 3,
          indicatorColor: Colors.white,
        ),
      );

  //获取标签切换tab widgets
  List<Widget> _getTagBarWidgets() => <Widget>[
        Text('文章'),
        Text('项目'),
        Text('体系'),
      ];

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }
}
