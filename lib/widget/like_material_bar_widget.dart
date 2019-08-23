import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LikeMaterialBarGroup extends StatefulWidget {
  final LikeMaterialBar head;
  final Widget body;
  final Color color;

  LikeMaterialBarGroup({@required this.head, @required this.body,this.color});

  @override
  State<StatefulWidget> createState() => LikeMaterialBarGroupState();
}

class LikeMaterialBarGroupState extends State<LikeMaterialBarGroup>
    with SingleTickerProviderStateMixin{

  ValueNotifier<double> topPosition = ValueNotifier(0.0);

  ValueNotifier<double> topBarMaxHeight = ValueNotifier(0.0);

  get hideHeight => widget.head.keyHide.currentContext?.size?.height??0;
  get adsorbHeight => widget.head.keyAdsorb.currentContext?.size?.height??0;


  double topMaxPos = 0.0;
  get topMinPos => -hideHeight;

  double verticalScrollPosition;

  bool animShowTopBar = true; //显示还是隐藏bar

  AnimationController _controller;

  @override
  void initState() {
    var widgetsBinding = WidgetsBinding.instance;
    widgetsBinding.addPostFrameCallback((callback) {
      //初始化数据
      topBarMaxHeight.value = hideHeight + adsorbHeight;
    });
    _controller =
        AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    _controller.addListener(() {
      if (animShowTopBar) {
        topPosition.value = topMinPos * (1.0 - _controller.value);
      } else
        topPosition.value = topMinPos * _controller.value;
    });
    verticalScrollPosition = 0.0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: widget.color,
      child: ConstrainedBox(
        constraints: BoxConstraints.expand(),
        child: NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification notification) {
            if (notification.metrics.axis == Axis.horizontal) return false;
            switch (notification.runtimeType) {
              case ScrollUpdateNotification:
                _stopAnim();
                _updateTopBar(
                    -(notification as ScrollUpdateNotification).scrollDelta);
                break;
              case ScrollEndNotification:
                _doTopBarAnim();
                break;
            }
            return false;
          },
          child: Stack(
            children: <Widget>[
              NestedScrollView(
                headerSliverBuilder: (context, inner) => <Widget>[
                  SliverToBoxAdapter(
                    child: ChangeNotifierProvider<ValueNotifier<double>>.value(
                      value: topBarMaxHeight,
                      child: Consumer<ValueNotifier<double>>(
                        builder: (context, data, _) => Container(
                          height: data.value,
                          color: widget.color,
                        ),
                      ),
                    ),
                  ),
                ],
                body: widget.body,
              ),
              ChangeNotifierProvider<ValueNotifier<double>>.value(
                value: topPosition,
                child: Consumer<ValueNotifier<double>>(
                  builder: (context, data, _) => Positioned(
                    top: data.value,
                    child: widget.head,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _doTopBarAnim() {
    double curTop = topPosition.value;
    double startPos;
    if (curTop == topMaxPos || curTop == topMinPos || _controller.isAnimating)
      return;
    if (curTop < topMinPos / 2 && verticalScrollPosition < topMinPos) {
      //执行隐藏动画
      animShowTopBar = false;
      startPos = curTop / topMinPos;
    } else {
      //执行显示动画
      animShowTopBar = true;
      startPos = 1.0 - curTop / topMinPos;
    }
    _controller.forward(from: startPos);
  }

  _updateTopBar(double dy) {
    verticalScrollPosition += dy;
    double needPos = topPosition.value + dy;
    if (needPos > topMaxPos) needPos = topMaxPos;
    if (needPos < topMinPos) needPos = topMinPos;
    if (topPosition.value != needPos) topPosition.value = needPos;
  }

  void _stopAnim() {
    if (_controller.isAnimating) _controller.stop(canceled: true);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}

class LikeMaterialBar extends StatelessWidget {

  final Widget hide;
  final Widget adsorb;
  final GlobalKey keyHide = GlobalKey();
  final GlobalKey keyAdsorb = GlobalKey();
  final Color color;
  final Decoration decoration;
  LikeMaterialBar({
    this.hide,
    this.adsorb,
    this.decoration,
    this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      color:color,
      decoration: decoration,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: <Widget>[
          Container(
            key: keyHide,
            child: hide,
          ),
          Container(
            key: keyAdsorb,
            child: adsorb,
          ),
        ],
      ),
    );
  }
}
