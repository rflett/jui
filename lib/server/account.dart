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

  static Future<String> signUp(SignUpRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(signupUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = LoginResponse.fromJson(json.decode(response.body));

    _storeToken(responseObj);

    return responseObj.user.name;
  }

  static Future<String> signIn(SignInRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(signinUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = LoginResponse.fromJson(json.decode(response.body));

    _storeToken(responseObj);

    return responseObj.user.name;
  }

  /// Stores the JWT token from the LoginResponse in the DeviceStorage
  static void _storeToken(LoginResponse response) async {
    await DeviceStorage.storeValue("jwt", response.token);
    _apiServer.updateTokenType(response.tokenType);
    _apiServer.updateToken(response.token);
  }
}
