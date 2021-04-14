import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/request/account/signin.dart';
import 'package:jui/models/dto/request/account/signup.dart';
import 'package:jui/models/dto/response/account/login_response.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/utilities/storage.dart';

import 'api_server.dart';
import 'base/api_request.dart';

class Account {
  static final _apiServer = ApiServer.instance;

  static Future<UserResponse> signUp(SignUpRequest requestData) async {
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
    _storeGroup(responseObj);

    return responseObj.user;
  }

  static Future<UserResponse> signIn(SignInRequest requestData) async {
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
    _storeGroup(responseObj);

    return responseObj.user;
  }

  /// Stores the JWT token from the LoginResponse in the DeviceStorage
  static void _storeToken(LoginResponse response) async {
    await DeviceStorage.storeValue(storageJwtKey, response.token);
    _apiServer.updateTokenType(response.tokenType);
    _apiServer.updateToken(response.token);
  }

  /// Stores the primary group (the first in the list response) in the DeviceStorage
  static void _storeGroup(LoginResponse response) async {
    var storedGroupId = await DeviceStorage.retrieveValue(storagePrimaryGroupId);

    if (response.user.groupIDs == null) {
      // user isn't in any groups
      return;
    }

    // primary group
    var groupId = response.user.groupIDs?[0];

    // store group id if it doesn't match
    if (storedGroupId != groupId) {
      await DeviceStorage.storeValue(storagePrimaryGroupId, groupId!);
    }
  }
}
