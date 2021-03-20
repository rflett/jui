import 'package:json_annotation/json_annotation.dart';

part 'create_update_group.g.dart';

@JsonSerializable()
@JsonSerializable()
class CreateUpdateGroup {
  final String name;

  CreateUpdateGroup(this.name);

  factory CreateUpdateGroup.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateGroupFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUpdateGroupToJson(this);
}