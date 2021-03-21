import 'package:json_annotation/json_annotation.dart';

part 'group_response.g.dart';

@JsonSerializable()
class GroupResponse {
  final String groupID;
  final String ownerID;
  final String name;
  final String code;
  final String createdAt;
  final String? updatedAt;

  GroupResponse(this.groupID, this.ownerID, this.name, this.code,
      this.createdAt, this.updatedAt);

  factory GroupResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupResponseToJson(this);
}
