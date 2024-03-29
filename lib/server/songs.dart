import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/response/played_songs_response.dart';
import 'package:jui/server/api_server.dart';

import 'base/api_request.dart';

class Songs {
  static final _apiServer = ApiServer.instance;

  /// get recently played songs
  static Future<PlayedSongsResponse> getPlayed() async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get(playedSongsUrl);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = PlayedSongsResponse.fromJson(json.decode(response.body));
    return responseObj;
  }
}
