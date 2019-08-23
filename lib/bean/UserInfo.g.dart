// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'UserInfo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserInfo _$UserInfoFromJson(Map<String, dynamic> json) {
  return UserInfo(
      admin: json['admin'] as bool,
      chapterTops:
          (json['chapterTops'] as List)?.map((e) => e as int)?.toList(),
      collectIds: (json['collectIds'] as List)?.map((e) => e as int)?.toList(),
      email: json['email'] as String,
      icon: json['icon'] as String,
      id: json['id'] as int,
      nickname: json['nickname'] as String,
      password: json['password'] as String,
      token: json['token'] as String,
      type: json['type'] as int,
      username: json['username'] as String);
}

Map<String, dynamic> _$UserInfoToJson(UserInfo instance) => <String, dynamic>{
      'admin': instance.admin,
      'chapterTops': instance.chapterTops,
      'collectIds': instance.collectIds,
      'email': instance.email,
      'icon': instance.icon,
      'id': instance.id,
      'nickname': instance.nickname,
      'password': instance.password,
      'token': instance.token,
      'type': instance.type,
      'username': instance.username
    };
