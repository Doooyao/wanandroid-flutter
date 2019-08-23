import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappbrowser/flutter_inappbrowser.dart';

class WanWebPage extends StatefulWidget {
  final String url;

  WanWebPage({this.url});

  @override
  State<StatefulWidget> createState() {
    return WanWebPageState();
  }
}

class WanWebPageState extends State<WanWebPage>
    with SingleTickerProviderStateMixin {
  InAppWebViewController webView;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: Hero(tag: 'articleName${widget.url}', child: Text('WanAndroid')),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
            initialUrl: widget.url,
          ),
        ],
      ),
    );
  }
}

class ArticleWebPage extends StatelessWidget {
  final String url;

  final String title;
  const ArticleWebPage({this.url, this.title, });


  @override
  Widget build(BuildContext context) {
    VerticalDragGestureRecognizer recognizer = VerticalDragGestureRecognizer();
    Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = Set();
    Factory<OneSequenceGestureRecognizer> factory = Factory(()=>recognizer);
    gestureRecognizers.add(factory);

    return new Scaffold(
      appBar: new AppBar(
        title: Text(title??"WanAndroid"),
      ),
      body: Stack(
        children: <Widget>[
          InAppWebView(
//            gestureRecognizers: gestureRecognizers,
            initialUrl: url,
//            onScrollChanged: (cont,x,y){
//              print('x:$x,y:$y');
//            },
          ),
        ],
      ),
    );
  }
}
