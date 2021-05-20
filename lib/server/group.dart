import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/storage_values.dart';
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/request/group/create_update_group.dart';
import 'package:jui/models/dto/request/group/join_group.dart';
import 'package:jui/models/dto/request/group/update_group_owner.dart';
import 'package:jui/models/dto/response/group/group_games_response.dart';
import 'package:jui/models/dto/response/group/group_members_response.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/server/api_server.dart';
import 'package:jui/utilities/storage.dart';

import 'base/api_request.dart';

class Group {
  static final _apiServer = ApiServer.instance;

  /// create a group
  static Future<GroupResponse> create(
      CreateUpdateGroupRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(groupUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GroupResponse.fromJson(json.decode(response.body));
    _storeGroupId(responseObj.groupID);
    return responseObj;
  }

  /// update a group
  static Future<void> update(
      String groupId, CreateUpdateGroupRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.put("$groupUrl/$groupId", jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// get a group
  static Future<GroupResponse> get(String groupId) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get("$groupUrl/$groupId");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GroupResponse.fromJson(json.decode(response.body));
    return responseObj;
  }

  /// get the members of a group, optionally with their votes as well
  static Future<GroupMembersResponse> getMembers(String groupId,
      {bool withVotes = false}) async {
    // TODO sprintf deprecated, remove once figured out routing
    var url = "$groupUrl/$groupId/members?withVotes=${withVotes.toString()}";

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get(url);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GroupMembersResponse.fromJson(json.decode(response.body));
    return responseObj;
  }

  /// get the games that a group has
  static Future<GroupGamesResponse> getGames(String groupId) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get("$groupUrl/$groupId/game");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GroupGamesResponse.fromJson(json.decode(response.body));
    return responseObj;
  }

  /// returns a base64 encoded png of a group QR code
  static Future<String> getQR(String groupId) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get("$groupUrl/$groupId/qr");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    return response.body;
  }

  /// request to join a group
  static Future<GroupResponse> join(JoinGroupRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(groupJoinUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GroupResponse.fromJson(json.decode(response.body));
    _storeGroupId(responseObj.groupID);
    return responseObj;
  }

  /// leave your group
  static Future<void> leave(String groupId, String userId) async {
    http.Response response = http.Response("", 500);
    try {
      response =
      await _apiServer.delete("$groupUrl/$groupId/members/$userId");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// update the group owner
  static Future<void> updateOwner(UpdateGroupOwnerRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());
    
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post("$groupUrl/nominate", jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// leave your group
  static Future<void> delete(String groupId) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.delete("$groupUrl/$groupId");
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// Stores the groupID in local storage as the primary group ID
  static void _storeGroupId(String groupId) async {
    await DeviceStorage.storeValue(storagePrimaryGroupId, groupId);
  }
}
