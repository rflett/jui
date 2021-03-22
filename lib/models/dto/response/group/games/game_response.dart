import 'package:json_annotation/json_annotation.dart';

part 'game_response.g.dart';

@JsonSerializable()
class GameResponse {
  final String gameID;
  final String groupID;
  final String name;
  final String description;
  final String createdAt;
  final String? updatedAt;

  GameResponse(this.gameID, this.groupID, this.name, this.description,
      this.createdAt, this.updatedAt);

  factory GameResponse.fromJson(Map<String, dynamic> json) =>
      _$GameResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GameResponseToJson(this);
}
