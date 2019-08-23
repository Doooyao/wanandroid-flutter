// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'HotQuery.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HotQuery _$HotQueryFromJson(Map<String, dynamic> json) {
  return HotQuery(
      id: json['id'] as int,
      name: json['name'] as String,
      link: json['link'] as int,
      order: json['order'] as int,
      visible: json['visible'] as int);
}

Map<String, dynamic> _$HotQueryToJson(HotQuery instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'link': instance.link,
      'order': instance.order,
      'visible': instance.visible
    };
