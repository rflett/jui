import 'package:json_annotation/json_annotation.dart';

part 'update_group_owner.g.dart';

@JsonSerializable()
class UpdateGroupOwnerRequest {
  final String groupID;
  final String userID;

  UpdateGroupOwnerRequest(this.groupID, this.userID);

  factory UpdateGroupOwnerRequest.fromJson(Map<String, dynamic> json) =>
      _$UpdateGroupOwnerRequestFromJson(json);

  Map<String, dynamic> toJson() => _$UpdateGroupOwnerRequestToJson(this);
}
