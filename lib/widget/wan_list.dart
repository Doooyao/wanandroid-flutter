import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/notifier_utils.dart';
import 'dart:math';

enum LoadMoreState {
  hasMoreData, //可加载更多
  onLoading, //加载中
  noMoreData, //没有数据可以加载了
  loadError, //数据加载错误
}

/// 请求数据，如果没有更多了需要返回空数组
typedef Future<List<T>> DataRequest<T>(int page);
typedef Widget ItemBuilder<T>(
    BuildContext context, int index, ValueNotifier<T> data);

class WanListWidget<T> extends StatefulWidget {
  final ItemBuilder<T> itemBuilder;
  final DataRequest<T> dataRequest;
  final Color color;
  final GlobalKey key;
  final ListNotifier<T> dataContainer;

  WanListWidget(
      {this.itemBuilder,
      this.dataRequest,
      this.color,
      this.key,
      this.dataContainer})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return WanListWidgetState<T>();
  }
}

class WanListWidgetState<T> extends State<WanListWidget<T>>
    with AutomaticKeepAliveClientMixin, TickerProviderStateMixin {
  int curPage;

  ValueNotifier<bool> isRefreshing = ValueNotifier(false);

  ListNotifier<T> list;

  ValueNotifier<LoadMoreState> loadMoreState =
      ValueNotifier(LoadMoreState.hasMoreData);

  Map<int, GlobalKey> listItemKeys = HashMap<int, GlobalKey>();
  Map<int, AnimationController> listItemAnims =
      HashMap<int, AnimationController>();

  int firstItemVisible = 0;
  int lastItemVisible = 0;

  GlobalKey listKey = GlobalKey();

  @override
  void initState() {
    list = widget.dataContainer ?? ListNotifier(List());
    curPage = 0;
    refreshData(false);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ListNotifier<T>>.value(value: list),
        ChangeNotifierProvider<ValueNotifier<LoadMoreState>>.value(
            value: loadMoreState),
        ChangeNotifierProvider<ValueNotifier<bool>>.value(value: isRefreshing),
      ],
      child: Consumer<ListNotifier<T>>(
        builder: (context, data, _) => Container(
          color: widget.color,
          child: Stack(
            children: <Widget>[
              Consumer<ValueNotifier<bool>>(
                builder: (context, refreshing, _) => data.list.length == 0
                    ? refreshing.value
                        ? SpinKitRing(
                            color: Colors.pink,
                            size: 50,
                            lineWidth: 4,
                          )
                        : Center(
                            child: Text(
                              '～这里空空如也～',
                              style: WanStyle.lightMiddleText,
                            ),
                          )
                    : Container(height: 0.0, width: 0.0),
              ),
              RefreshIndicator(
                onRefresh: () => refreshData(false),
                child: NotificationListener<ScrollNotification>(
                  onNotification: (notify) {
                    if (notify.metrics.axis != Axis.vertical) return false;
                    if (notify.metrics.maxScrollExtent == notify.metrics.pixels)
                      _loadMore(); //加载更多
                    if (notify is ScrollUpdateNotification) {
                      List<int> range = _calculateItemVisibleRange();
                      _checkForDoAnim(range);
                    }
                    return false;
                  },
                  child: ListView.builder(
                    key: listKey,
                    itemCount: _itemCounter(data.list),
                    physics: const AlwaysScrollableScrollPhysics(),
                    itemBuilder: (context, index,) {
                      return ScaleTransition(
                        scale: _getItemAnimCtr(index),
                        key: _getItemGlobalKey(index),
                        child: index < data.list.length
                            ? ChangeNotifierProvider<ValueNotifier<T>>.value(
                          value: ValueNotifier(data.list[index]),
                          child: Consumer<ValueNotifier<T>>(
                            builder: (context, itemData, _) => widget
                                .itemBuilder(context, index, itemData),
                          ),
                        )
                            : _getListFootView(),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  int _itemCounter(List<T> data) => data.length == 0 ? 0 : data.length + 1;

  Widget _getListFootView() => Consumer<ValueNotifier<LoadMoreState>>(
        builder: (context, data, _) => SizedBox(
          height: 50,
          child: _selectFootView(data.value),
        ),
      );

  //
  void insert(T item,{int index}){
    list.update((data){
      data.insert(index??data.length, item);
    });
  }

  void remove(T item){
    list.update((data){
      data.remove(item);
    });
  }

  Widget _selectFootView(LoadMoreState curState) {
    switch (curState) {
      case LoadMoreState.hasMoreData:
        return Center(
          child: Text('上拉加载更多数据'),
        );
      case LoadMoreState.onLoading:
        return SpinKitRing(
          color: Colors.orange,
          lineWidth: 4,
          size: 25,
        );
      case LoadMoreState.noMoreData:
        return Center(
          child: Text('没有更多数据啦'),
        );
      case LoadMoreState.loadError:
        return Center(
          child: Text('网络出现问题了TT'),
        );
    }
    return Container(
      width: 0,
      height: 0,
    );
  }

  /// 加载更多数据
  _loadMore<T>() {
    if (loadMoreState.value == LoadMoreState.hasMoreData) {
      loadMoreState.value = LoadMoreState.onLoading;
      widget.dataRequest(curPage++).then((newList) {
        //数据加载完毕
        if (newList.length == 0) {
          loadMoreState.value = LoadMoreState.noMoreData;
        } else {
          list.update((data) {
            data.addAll(newList);
          });
          loadMoreState.value = LoadMoreState.hasMoreData;
        }
      });
    }
  }

  ///第一次请求数据或者刷新数据
  Future<void> refreshData(bool clearOldAtOnce) async {
    isRefreshing.value = true;
    curPage = 0;
    if (clearOldAtOnce)
      list.update(
        (data) => data.clear(),
      );
    await widget.dataRequest(curPage++).then((newList) {
      list.update((data) {
        isRefreshing.value = false;
        data.clear();
        data.addAll(newList);
      });
    });
  }

  GlobalKey _getItemGlobalKey(int index) {
    listItemKeys[index] ??= GlobalKey();
    return listItemKeys[index];
  }

  AnimationController _getItemAnimCtr(int index) {
    listItemAnims[index] ??= AnimationController(
        vsync: this,
        duration: Duration(milliseconds: 300),
        lowerBound: 0.95,
        value: 1.0)
      ..forward(from: .95);
    return listItemAnims[index];
  }

  @override
  bool get wantKeepAlive => true;

  List<int> _calculateItemVisibleRange() {
    List<int> res = List(2);
    double top = (listKey.currentContext.findRenderObject() as RenderBox)
        .localToGlobal(Offset.zero)
        .dy;
    double bottom = min(MediaQuery.of(context).size.height,
        top + listKey.currentContext.size.height);
    for (int i = 0; i < listItemKeys.length; i++) {
      BuildContext itemContext = listItemKeys[i].currentContext;
      double itemBottom = ((itemContext?.findRenderObject() as RenderBox)
                  ?.localToGlobal(Offset.zero)
                  ?.dy ??
              -20000) +
          (itemContext?.size?.height ?? 0);
      if (itemBottom > top) {
        //第一个可见的
        res[0] = i;
        break;
      }
    }
    for (int i = listItemKeys.length - 1; i >= 0; i--) {
      BuildContext itemContext = listItemKeys[i].currentContext;
      double itemTop = (itemContext?.findRenderObject() as RenderBox)
              ?.localToGlobal(Offset.zero)
              ?.dy ??
          20000;
      if (itemTop < bottom) {
        res[1] = i;
        break;
      }
    }
    return res;
  }

  void _checkForDoAnim(List<int> range) {
    if (range[0] < firstItemVisible) {
      for (int i = range[0] - 1; i < firstItemVisible; i++) {
        _doItemAnim(i);
      }
    }
    firstItemVisible = range[0];
    if (range[1] > lastItemVisible) {
      for (int i = range[1] + 1; i > lastItemVisible + 1; i--) {
        _doItemAnim(i);
      }
    }
    lastItemVisible = range[1];
  }

  void _doItemAnim(int index) {
    if (index < 0 || index > listItemKeys.length - 1) return;
    ((listItemKeys[index].currentWidget as ScaleTransition)?.scale
            as AnimationController)
        ?.forward(from: 0.95);
  }

  @override
  void dispose() {
    listItemAnims.forEach((index, ctr) {
      ctr.dispose();
    });
    super.dispose();
  }
}
