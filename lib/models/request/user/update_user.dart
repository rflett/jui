import 'package:json_annotation/json_annotation.dart';

part 'update_user.g.dart';

@JsonSerializable()
class UpdateUser {
  final String nickName;

  UpdateUser(this.nickName);

  factory UpdateUser.fromJson(Map<String, dynamic> json) =>
      _$UpdateUserFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateUserToJson(this);
}
