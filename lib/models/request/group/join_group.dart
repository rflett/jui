import 'package:json_annotation/json_annotation.dart';

part 'join_group.g.dart';

@JsonSerializable()
class JoinGroup {
  final String code;

  JoinGroup(this.code);

  factory JoinGroup.fromJson(Map<String, dynamic> json) =>
      _$JoinGroupFromJson(json);

  Map<String, dynamic> toJson() => _$JoinGroupToJson(this);
}
