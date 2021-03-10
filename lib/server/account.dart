import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:friendsbet/constants/urls.dart';
import 'package:friendsbet/models/request/login_request.dart';
import 'package:friendsbet/models/request/registration_request.dart';
import 'package:friendsbet/models/response/login_response.dart';
import 'package:friendsbet/models/response/problem_response.dart';
import 'package:friendsbet/server/api_server.dart';
import 'package:friendsbet/server/base/api_request.dart';
import 'package:friendsbet/utilities/storage.dart';
import 'package:http/http.dart' as http;

class Account {
  static final _apiServer = ApiServer.instance;

  static Future<String> register(RegistrationRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response;
    try {
      response =
          await _apiServer.post(registerUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = LoginResponse.fromJson(json.decode(response.body));

    if (responseObj.token != null) {
      await DeviceStorage.storeValue("jwt", responseObj.token);
      _apiServer.updateToken(responseObj.token);
    }

    return responseObj.name;
  }

  static Future<String> login(LoginRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response;
    try {
      response =
      await _apiServer.post(loginUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = LoginResponse.fromJson(json.decode(response.body));

    if (responseObj.token != null) {
      await DeviceStorage.storeValue("jwt", responseObj.token);
      _apiServer.updateToken(responseObj.token);
    }

    return responseObj.name;
  }
}
