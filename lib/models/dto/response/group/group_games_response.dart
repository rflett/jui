import 'package:json_annotation/json_annotation.dart';

import 'games/game_response.dart';

part 'group_games_response.g.dart';

@JsonSerializable()
class GroupGamesResponse {
  final List<GameResponse> games;

  GroupGamesResponse(this.games);

  factory GroupGamesResponse.fromJson(Map<String, dynamic> json) =>
      _$GroupGamesResponseFromJson(json);

  Map<String, dynamic> toJson() => _$GroupGamesResponseToJson(this);
}
