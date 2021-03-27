import 'package:json_annotation/json_annotation.dart';
import 'package:jui/models/dto/response/user/user.dart';

part 'group_members_response.g.dart';

@JsonSerializable()
class GroupMembersResponse {
  final List<UserResponse> members;

  GroupMembersResponse(this.members);

  factory GroupMembersResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupMembersResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupMembersResponseToJson(this);
}
