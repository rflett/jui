import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/response/vote_response.dart';
import 'package:jui/server/api_server.dart';

import 'base/api_request.dart';

class Group {
  static final _apiServer = ApiServer.instance;

  /// search for a song on spotify
  static Future<SearchResponse> search(String searchStr) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get("$searchUrl?query=$searchStr}");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = SearchResponse.fromJson(json.decode(response.body));
    return responseObj;
  }
}
