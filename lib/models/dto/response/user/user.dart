import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/shared/vote.dart';

part 'user.g.dart';

@JsonSerializable()
class UserResponse {
  final String userID;
  final String name;
  final String email;
  final int points;
  final DateTime createdAt;
  final List<GroupResponse>?
      groups; // groups is null if user is not in any group
  final String? nickName; // not set when signed up via socials
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
      this.groups,
      this.nickName,
      this.authProvider,
      this.authProviderId,
      this.avatarUrl,
      this.votes,
      this.updatedAt);

  factory UserResponse.fromJson(Map<String, dynamic> json) =>
      _$UserResponseFromJson(json);

  Map<String, dynamic> toJson() => _$UserResponseToJson(this);

  /// Returns whether or not the user was the creator / owner of the given group.
  bool isOwnerOf(GroupResponse? group) {
    return group != null && group.ownerID == userID;
  }
}
