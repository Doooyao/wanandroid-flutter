import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/HotQuery.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/common/util/navigator_utils.dart';
import 'package:wan_android_flutter/common/util/notifier_utils.dart';
import 'package:wan_android_flutter/page/search_result_page.dart';

import 'notify_listener.dart';

//搜索控件
class SearchBarWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return SearchBarWidgetState();
  }
}

//搜索控件
class SearchBarWidgetState extends State<SearchBarWidget> {
  GlobalKey barKey = GlobalKey();
  FocusNode node = FocusNode();
  OverlayEntry _overlayEntry;
  ListNotifier<HotQuery> hotQuery;
  TextEditingController _editController = TextEditingController();
  bool hasFocus = false;

  OverlayEntry _createSearchPopupWindow() => OverlayEntry(builder: (context) {
        return GestureDetector(
          onTap: () {
            _overlayEntry?.remove();
            hasFocus = false;
          },
          child: Container(
            margin: EdgeInsets.only(top: barOffset().dy),
            color: WanColor.dark_transparent,
            child: Stack(
              children: <Widget>[
                OnPostFrameListener(
                      onPost:() {
                    FocusScope.of(context).requestFocus(node);
                  },
                  child:_getSearchBars(true),
                ),
              ],
            ),
          ),
        );
      });

  Offset barOffset() => (barKey.currentContext.findRenderObject() as RenderBox)
      .localToGlobal(Offset.zero);

  Future<bool> _onWillpop() async{
    if(hasFocus){
      _overlayEntry.remove();
      hasFocus = false;
      return false;
    }
    return true;
  }

  @override
  Widget build(BuildContext context) {
    _editController.text = Provider.of<SearchQuery>(context).value;
    return WillPopScope(child: GestureDetector(
      onTap: () {
        _overlayEntry ??= _createSearchPopupWindow();
        Overlay.of(context).insert(_overlayEntry);
        hasFocus = true;
      },
      key: barKey,
      child: _getSearchBars(false),
    ),onWillPop: _onWillpop,);
  }

  Widget _getSearchBar(bool focus) => Container(
        height: 50,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Container(
                margin: EdgeInsets.only(left: 20),
                child: Consumer<SearchQuery>(
                  builder: (context, query, widget) => focus
                      ? TextField(
                          style: WanStyle.searchQuery,
                          focusNode: node,
                          maxLines: 1,
                          controller: _editController,
                          onSubmitted: (String str) {
                            //提交监听
                            _doSearch(str);
                          },
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                        )
                      : Text(
                          query.value == '' ? 'WanAndroid' : query.value,
                          style: query.value == ''
                              ? TextStyle(
                                  color: Colors.grey,
                                  fontSize: 16,
                                )
                              : WanStyle.searchQuery,
                        ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () => _doSearch(_editController.text),
              child: Container(
                margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
                child: Icon(Icons.search),
              ),
            ),
          ],
        ),
      );

  Widget _getSearchBars(bool focus) => Container(
        margin: EdgeInsets.fromLTRB(8, 8, 8, 0),
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(3)),
          color: Colors.white,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _getSearchBar(focus),
            ],
          ),
        ),
      );

  void _doSearch(String query) {
    Provider.of<SearchQuery>(context).value = query;
    _overlayEntry.remove();
    hasFocus = false;
    if(context.ancestorStateOfType(TypeMatcher<SearchResultPageState>())==null)
      NavigatorUtils.goSearchArticle(context);
  }
}

class SearchQuery extends ValueNotifier<String> {
  SearchQuery(String value) : super(value);
}
