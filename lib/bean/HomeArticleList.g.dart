// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HomeArticleList.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HomeArticleList _$HomeArticleListFromJson(Map<String, dynamic> json) {
  return HomeArticleList(
      datas: (json['datas'] as List)
          ?.map((e) => e == null
              ? null
              : HomeArticleBean.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      curPage: json['curPage'] as int,
      offset: json['offset'] as int,
      over: json['over'] as bool,
      pageCount: json['pageCount'] as int,
      size: json['size'] as int,
      total: json['total'] as int);
}

Map<String, dynamic> _$HomeArticleListToJson(HomeArticleList instance) =>
    <String, dynamic>{
      'datas': instance.datas,
      'curPage': instance.curPage,
      'offset': instance.offset,
      'over': instance.over,
      'pageCount': instance.pageCount,
      'size': instance.size,
      'total': instance.total
    };
