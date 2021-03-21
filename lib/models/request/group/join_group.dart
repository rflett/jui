import 'package:json_annotation/json_annotation.dart';

part 'join_group.g.dart';

@JsonSerializable()
class JoinGroupRequest {
  final String code;

  JoinGroupRequest(this.code);

  factory JoinGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$JoinGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$JoinGroupRequestToJson(this);
}
