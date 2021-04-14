import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/request/group/games/create_update_game.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';

import 'api_server.dart';
import 'base/api_request.dart';

class Game {
  static final _apiServer = ApiServer.instance;

  /// create a game
  static Future<GameResponse> create(
      String groupID, CreateUpdateGameRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post("$groupUrl/$groupID/game", jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GameResponse.fromJson(json.decode(response.body));
    return responseObj;
  }

  /// update a game
  static Future<void> update(String groupId, String gameId,
      CreateUpdateGameRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response =
          await _apiServer.put("$groupUrl/$groupId/game/$gameId", jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// delete a game
  static Future<void> delete(String groupId, String gameId) async {
    http.Response response = http.Response("", 500);
    try {
      response =
          await _apiServer.delete("$groupUrl/$groupId/game/$gameId");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }
}
