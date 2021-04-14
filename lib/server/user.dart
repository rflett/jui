import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/request/user/create_vote.dart';
import 'package:jui/models/dto/request/user/device/register_device.dart';
import 'package:jui/models/dto/request/user/update_user.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/api_server.dart';
import 'package:jui/server/base/api_request.dart';

class User {
  static final _apiServer = ApiServer.instance;

  /// update a user
  static Future<void> update(UpdateUserRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.put(userUpdateUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// get a user
  static Future<UserResponse> get(String userId,
      {bool withVotes = false}) async {
    var url = "$userGetUrl/$userId?withVotes=${withVotes.toString()}";

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get(url);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = UserResponse.fromJson(json.decode(response.body));
    return responseObj;
  }

  /// get the S3 pre-signed URL to modify a user's avatar
  static Future<String> getAvatarModifyURL() async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get(userAvatarUrl);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    return response.body;
  }

  /// create a song vote
  static Future<void> createVote(CreateVoteRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(userCreateVoteUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// remove a song vote
  static Future<void> removeVote(String songId) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.delete("$userDeleteVoteUrl/$songId");
      } catch (err)
      {
        print(err);
      }

      ApiRequest.handleErrors(response);
    }

  /// register a device for notifications
  static Future<void> registerDevice(RegisterDeviceRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(userDeviceUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }
}
