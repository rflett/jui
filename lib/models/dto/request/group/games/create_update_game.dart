import 'package:json_annotation/json_annotation.dart';

part 'create_update_game.g.dart';

@JsonSerializable()
class CreateUpdateGameRequest {
  final String name;
  final String description;

  CreateUpdateGameRequest(this.name, this.description);

  factory CreateUpdateGameRequest.fromJson(Map<String, dynamic> json) =>
      _$CreateUpdateGameRequestFromJson(json);

  Map<String, dynamic> toJson() => _$CreateUpdateGameRequestToJson(this);
}
