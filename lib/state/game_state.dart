import 'package:flutter/cupertino.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/server/group.dart';

class GameState extends ValueNotifier<List<GameResponse>> {
  GameState(List<GameResponse> value) : super(value);

  void loadGames(String groupId) async {
    var gamesResponse = await Group.getGames(groupId);
    value = gamesResponse.games;
  }
}
