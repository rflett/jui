import 'package:json_annotation/json_annotation.dart';

part 'create_update_group.g.dart';

@JsonSerializable()
class CreateUpdateGroupRequest {
  final String name;

  CreateUpdateGroupRequest(this.name);

  factory CreateUpdateGroupRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateGroupRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUpdateGroupRequestToJson(this);
}