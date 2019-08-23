import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/TagSystem.dart';
import 'package:wan_android_flutter/common/util/notifier_utils.dart';
import 'package:wan_android_flutter/page/system_content_page.dart';
import 'package:wan_android_flutter/widget/notify_listener.dart';
import 'dart:math';
import 'home_page_widget.dart';

class SystemTagTab extends StatefulWidget {
  final double shrinkRatio;

  final void Function(double unExpandHeight, double expandHeight) onPostFrame;

  SystemTagTab(double d, {this.onPostFrame}) : shrinkRatio = min(d, 1.0);

  @override
  State<StatefulWidget> createState() {
    print("createState");
    return SystemTagTabState();
  }
}

class SystemTagTabState extends State<SystemTagTab>
    with TickerProviderStateMixin {
  //扩展当前扩展状态

  bool curExpandState = false;

  GlobalKey unExpandKey = GlobalKey();
  GlobalKey expandKey = GlobalKey();

  GlobalKey expandItemKey = GlobalKey();
  GlobalKey unExpandItemKey = GlobalKey();

  GlobalKey rootKey = GlobalKey();

  Color unselectColor = Colors.grey;

  TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return Consumer2<ListNotifier<TagSystem>, SystemSelected>(
      builder: (context, tags, selected, _) => OnPostFrameListener(
        onPost: () {
          widget.onPostFrame?.call(
            unExpandKey.currentContext?.size?.height,
            expandKey.currentContext?.size?.height,
          );
        },
        child: Stack(
          key: rootKey,
          children: <Widget>[
            Opacity(
              key: unExpandKey,
              opacity: max(0.0, widget.shrinkRatio * 2 - 1),
              child: _unExpandWidget(tags, selected),
            ),
            widget.shrinkRatio == 1
                ? Container(
                    height: 0,
                  )
                : Opacity(
                    key: expandKey,
                    opacity: max(0.0, 1 - widget.shrinkRatio * 2),
                    child: _expandWidget(tags, selected),
                  ),
            Positioned(
              left: _getHeroItemPos().dx,
              top: _getHeroItemPos().dy,
              height: (widget.shrinkRatio == 0 || widget.shrinkRatio == 1)
                  ? 0
                  : null,
              child: TagSystemItem.singleBtn(selected.child),
            ),
          ],
        ),
      ),
    );
  }

  Offset _getHeroItemPos() {
    RenderBox unExpandbox = unExpandItemKey?.currentContext?.findRenderObject();
    RenderBox expandbox = expandItemKey?.currentContext?.findRenderObject();
    RenderBox rootBox = rootKey?.currentContext?.findRenderObject();
    Offset unExpandOffset =
        unExpandbox?.localToGlobal(Offset.zero, ancestor: rootBox) ??
            Offset.zero;
    Offset expandOffset =
        expandbox?.localToGlobal(Offset.zero, ancestor: rootBox) ?? Offset.zero;
    return Offset(
        expandOffset.dx -
            widget.shrinkRatio * (expandOffset.dx - unExpandOffset.dx),
        expandOffset.dy -
            widget.shrinkRatio * (expandOffset.dy - unExpandOffset.dy));
  }

  Widget _unExpandWidget(
          ListNotifier<TagSystem> tags, SystemSelected selected) =>
      Container(
        padding: EdgeInsets.all(8),
        child: TabBar(
          labelPadding: EdgeInsets.all(0),
          isScrollable: true,
          indicator: UnderlineTabIndicator(borderSide: BorderSide.none),
          controller: _getTabController(selected),
          tabs: selected.parent.children
              .map(
                (e) => Container(
                  color: Colors.white,
                  child: Container(
                    key: selected.child == e ? unExpandItemKey : null,
                    child: Opacity(
                      opacity:
                          (selected.child == e) && (widget.shrinkRatio != 1)
                              ? 0
                              : 1,
                      child: GestureDetector(
                        onTap: (){
                          if(widget.shrinkRatio == 1)
                              selected.child = e;
                        },
                        child: TagSystemItem.singleBtn(
                          e,
                          color: selected.child != e ? unselectColor : null,
                        ),
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

  Widget _expandWidget(ListNotifier<TagSystem> tags, SystemSelected selected) =>
      Container(
        padding: EdgeInsets.all(8),
        color: Colors.white,
        child: TagSystemItem.expandBtns(
          selected.parent.children,
          unSelectColor: unselectColor,
          selectedItem: selected.child,
          selectedKey: expandItemKey,
          hideSelected: widget.shrinkRatio != 0,
          tagCallback: (tagSystem){
            if(widget.shrinkRatio == 0)
              selected.child = tagSystem;
          }
        ),
      );

  Widget _transItemWidget(SystemSelected selected) => Positioned(
        child: TagSystemItem.singleBtn(selected.child),
      );

  TabController _getTabController(SystemSelected selected) {
    if (_tabController == null
        ||_tabController.length != selected.parent.children.length) {
      _tabController?.dispose();
      _tabController = TabController(length: selected.parent.children.length, vsync: this);
    }
    _tabController.index = selected.parent.children.indexOf(selected.child);
    return _tabController;
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
