// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'TagSystem.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TagSystem _$TagSystemFromJson(Map<String, dynamic> json) {
  return TagSystem(
      children: (json['children'] as List)
          ?.map((e) =>
              e == null ? null : TagSystem.fromJson(e as Map<String, dynamic>))
          ?.toList(),
      courseId: json['courseId'] as int,
      id: json['id'] as int,
      name: json['name'] as String,
      order: json['order'] as int,
      parentChapterId: json['parentChapterId'] as int,
      userControlSetTop: json['userControlSetTop'] as bool,
      visible: json['visible'] as int);
}

Map<String, dynamic> _$TagSystemToJson(TagSystem instance) => <String, dynamic>{
      'children': instance.children,
      'courseId': instance.courseId,
      'id': instance.id,
      'name': instance.name,
      'order': instance.order,
      'parentChapterId': instance.parentChapterId,
      'userControlSetTop': instance.userControlSetTop,
      'visible': instance.visible
    };
