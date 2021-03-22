import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/request/account/signin.dart';
import 'package:jui/models/dto/request/account/signup.dart';
import 'package:jui/models/dto/response/account/login_response.dart';
import 'package:jui/utilities/storage.dart';

import 'api_server.dart';
import 'base/api_request.dart';

class Account {
  static final _apiServer = ApiServer.instance;

  static Future<String> register(SignUpRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(registerUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = LoginResponse.fromJson(json.decode(response.body));

    await DeviceStorage.storeValue("jwt", responseObj.token);
    _apiServer.updateTokenType(responseObj.tokenType);
    _apiServer.updateToken(responseObj.token);

    return responseObj.user.name;
  }

  static Future<String> login(SignInRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(loginUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = LoginResponse.fromJson(json.decode(response.body));

    await DeviceStorage.storeValue("jwt", responseObj.token);
    _apiServer.updateTokenType(responseObj.tokenType);
    _apiServer.updateToken(responseObj.token);

    return responseObj.user.name;
  }
}
