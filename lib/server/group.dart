import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/request/group/create_update_group.dart';
import 'package:jui/models/dto/request/group/join_group.dart';
import 'package:jui/models/dto/response/group/group_games_response.dart';
import 'package:jui/models/dto/response/group/group_members_response.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/server/api_server.dart';
import 'package:sprintf/sprintf.dart';

import 'base/api_request.dart';

class Group {
  static final _apiServer = ApiServer.instance;

  /// create a group
  static Future<GroupResponse> create(
      CreateUpdateGroupRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(groupBaseUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    var responseObj = GroupResponse.fromJson(json.decode(response.body));
    return responseObj;
  }

  /// update a group
  static Future<void> update(
      String groupId, CreateUpdateGroupRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.put(sprintf(groupUrl, [groupId]), jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// get a group
  static Future<GroupResponse> get(String groupId) async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.get(sprintf(groupUrl, [groupId]));
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
    var url = sprintf(groupMembersUrl, groupId) + withVotes.toString();

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
      response = await _apiServer.get(sprintf(gameBaseUrl, [groupId]));
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
      response = await _apiServer.get(sprintf(groupQrUrl, groupId));
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);

    // Response succeeded
    return response.body;
  }

  /// request to join a group
  static Future<void> join(String groupId, JoinGroupRequest requestData) async {
    var jsonBody = json.encode(requestData.toJson());

    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.post(groupMembershipUrl, jsonBody);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }

  /// leave your group
  static Future<void> leave() async {
    http.Response response = http.Response("", 500);
    try {
      response = await _apiServer.delete(groupMembershipUrl);
    } catch (err) {
      print(err);
    }

    ApiRequest.handleErrors(response);
  }
}
