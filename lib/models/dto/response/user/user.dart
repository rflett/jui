import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/shared/vote.dart';

part 'user.g.dart';

@JsonSerializable()
class UserResponse {
  final String userID;
  final String name;
  final String email;
  final int points;
  final DateTime createdAt;
  final String? groupID;
  final String nickName;
  final String authProvider;
  final String authProviderId;
  final String? avatarUrl;
  final List<Vote>? votes;
  final DateTime? updatedAt;

  UserResponse(
      this.userID,
      this.name,
      this.email,
      this.points,
      this.createdAt,
      this.groupID,
      this.nickName,
      this.authProvider,
      this.authProviderId,
      this.avatarUrl,
      this.votes,
      this.updatedAt);

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);
}
