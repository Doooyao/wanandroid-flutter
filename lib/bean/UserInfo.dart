import 'package:json_annotation/json_annotation.dart';

part 'UserInfo.g.dart';

@JsonSerializable()
class UserInfo{
  bool admin;
  List<int> chapterTops;
  List<int> collectIds;
  String email;
  String icon;
  int id;
  String nickname;
  String password;
  String token;
  int type;
  String username;

  UserInfo(
      {this.admin,
        this.chapterTops,
        this.collectIds,
        this.email,
        this.icon,
        this.id,
        this.nickname,
        this.password,
        this.token,
        this.type,
        this.username});

  factory UserInfo.fromJson(Map<String, dynamic> json) => _$UserInfoFromJson(json);

}
