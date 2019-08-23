import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wan_android_flutter/bean/HomeArticleBean.dart';
import 'package:wan_android_flutter/bean/TagSystem.dart';
import 'package:wan_android_flutter/bean/UserInfo.dart';
import 'package:wan_android_flutter/common/callbacks.dart';
import 'package:wan_android_flutter/common/style/wan_style.dart';
import 'package:wan_android_flutter/widget/custom_widget.dart';

///首页最新文章item
class HomeArticleItem extends StatelessWidget {
  final HomeArticleBean data;
  final VoidCallback onItemPressed;
  final IntCallback onTagIndexPressed;
  final VoidCallback onChapterClick;
  final String heroTag;
  final VoidCallback onCollectClick;

  HomeArticleItem(
    this.data, {
    this.onItemPressed,
    this.onTagIndexPressed,
    this.onChapterClick,
    this.heroTag,
    this.onCollectClick,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onItemPressed ?? () {},
      child: Container(
        color: Colors.white,
        margin: EdgeInsets.only(bottom: 0.5),
        padding: EdgeInsets.all(8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Row(
                  children: data.tags
                      ?.asMap()
                      ?.map(
                        (index, tag) => MapEntry<int, Widget>(
                          index,
                          Container(
                            margin: EdgeInsets.only(right: 4),
                            child: WanTag(
                              tag.name,
                              onTagPressed: () =>
                                  onTagIndexPressed?.call(index),
                            ),
                          ),
                        ),
                      )
                      ?.values
                      ?.toList()??<Widget>[Container()],
                ),
                Expanded(
                  child: Container(
                    margin:
                        EdgeInsets.only(left: (data.tags?.length??0) == 0 ? 0 : 4),
                    child: IconText(
                      IconText.startIcon,
                      Icons.person,
                      Text(
                        data.author,
                        style: WanStyle.simpleButtonText,
                      ),
                      iconPadding: 2,
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: onChapterClick ?? () {},
                  child: Row(
                    children: <Widget>[
                      Text(
                        data.superChapterName??'',
                        style: WanStyle.simpleButtonText,
                      ),
                      Text(
                        '/',
                        style: WanStyle.simpleButtonText,
                      ),
                      Text(
                        data.chapterName??'',
                        style: WanStyle.simpleButtonText,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: heroTag == null
                  ? Text(data.title,
                      textAlign: TextAlign.left,
                      style: WanStyle.homeArticleTitle)
                  : Hero(
                      tag: heroTag,
                      child: Text(data.title,
                          textAlign: TextAlign.left,
                          style: WanStyle.homeArticleTitle),
                    ),
            ),
            Container(
              margin: EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: IconText(
                      IconText.startIcon,
                      Icons.timer,
                      Text(
                        data.niceDate,
                        style: WanStyle.simpleButtonText,
                      ),
                      iconPadding: 2,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => onCollectClick?.call(),
                    child: data.collect??false
                        ? Icon(Icons.star)
                        : Icon(Icons.star_border),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

///首页最新项目item
class HomeProjectItem extends StatelessWidget {
  final HomeArticleBean data;
  final VoidCallback onItemPressed;
  final VoidCallback onPicClick;
  final VoidCallback onCollectClick;
  final int index;
  final Radius radius = Radius.circular(6);

  HomeProjectItem(
    this.data,
    this.index, {
    this.onItemPressed,
    this.onPicClick,
    this.onCollectClick,
  }) : super();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 3,
      margin: EdgeInsets.fromLTRB(8, index == 0 ? 8 : 4, 8, 4),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(radius)),
      child: GestureDetector(
        onTap: onItemPressed ?? () {},
        child: Container(
          margin: EdgeInsets.fromLTRB(14, 10, 14, 10),
          child: Column(
            children: <Widget>[
              Container(
                margin: EdgeInsets.only(bottom: 4),
                child: Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        child: IconText(
                          IconText.startIcon,
                          Icons.person,
                          Text(
                            data.author,
                            style: WanStyle.lightMiddleText,
                          ),
                          iconPadding: 2,
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => onCollectClick?.call(),
                      child: data.collect??true
                          ? Icon(Icons.star)
                          : Icon(Icons.star_border),
                    ),
                  ],
                ),
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    child: Container(
                      margin: EdgeInsets.fromLTRB(0, 0, 14, 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            child: Text(
                              data.title.trim(),
                              style: WanStyle.homeProjectTitle,
                              maxLines: 2,
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 4),
                            child: Text(
                              data.desc.trim(),
                              maxLines: 3,
                              style: WanStyle.homeProjectDesc,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: onPicClick ?? () {},
                    child: Container(
                      margin: EdgeInsets.only(top: 4),
                      child: Image.network(
                        data.envelopePic,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ],
              ),
              IconText(
                IconText.startIcon,
                Icons.timer,
                Text(
                  data.niceDate,
                  style: WanStyle.simpleButtonText,
                ),
                iconPadding: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

typedef void OnTagClick(TagSystem father, TagSystem child);

//首页tag体系item及相关
class TagSystemItem {
  static final List<Color> tagColors = <Color>[
    Colors.blue,
    Colors.amberAccent,
    Colors.green,
    Colors.orange,
    Colors.red,
    Colors.pink,
  ];

  static Color getTagColor(String name) =>
      tagColors[name.hashCode % tagColors.length];

  /// 单个系统标签
  /// [tagSystem] 标签数据 单个
  /// [color] 标签颜色，默认按照顺序选择，可以设置颜色，代表未选择
  static Widget singleBtn(
    TagSystem tagSystem, {
    Color color,
  }) =>
      Padding(
        padding: EdgeInsets.all(3),
        child: Chip(
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          key: ValueKey<String>(tagSystem.name),
          label: Text(
            tagSystem.name,
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
            ),
          ),
          backgroundColor: color ?? getTagColor(tagSystem.name),
        ),
      );

  /// 展开的状态
  /// [tags] 数据
  /// [unSelectColor] 未被选中的颜色，如果不传则全都带颜色
  /// [selectedItem] 被选中的
  /// [tagCallback] 标签点击事件
  static Widget expandBtns(List<TagSystem> tags,
          {Color unSelectColor,
          TagSystem selectedItem,
          bool hideSelected = false,
          void Function(TagSystem tag) tagCallback,
          GlobalKey selectedKey}) =>
      Container(
        child: Wrap(
          children: tags
              .map(
                (e) => GestureDetector(
                  onTap: () => tagCallback?.call(e),
                  child: Container(
                    key: e == selectedItem ? selectedKey : null,
                    child: Opacity(
                      opacity: hideSelected && e == selectedItem ? 0 : 1,
                      child: singleBtn(e,
                          color: (unSelectColor != null && e != selectedItem)
                              ? unSelectColor
                              : getTagColor(e.name)),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      );

  /// 主页的tagItem
  /// [parent] 包括孩子tag的父tag
  /// [onTagClick] 子tag点击监听
  static Widget homePageItem(TagSystem parent,
          {void Function(TagSystem parent, TagSystem child) onTagClick}) =>
      Padding(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              child: Text(
                parent.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              margin: EdgeInsets.fromLTRB(5, 0, 0, 3),
            ),
            expandBtns(parent.children, tagCallback: (child) {
              onTagClick?.call(parent, child);
            }),
          ],
        ),
        padding: EdgeInsets.all(8),
      );
}
