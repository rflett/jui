import 'package:flutter/material.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/request/group/create_update_group.dart';
import 'package:jui/models/dto/request/group/games/create_update_game.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/game.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/server/group.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/utilities/token.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // loading spinners visibility
  bool profileIsLoading = true;
  bool groupsAreLoading = true;
  bool membersAreLoading = true;
  bool gamesAreLoading = true;
  // control whether components are visible
  bool isGroupOwner = false;
  bool createGroupVisible = false;
  bool createGameVisible = false;
  // used across the different tabs
  UserResponse? _user;
  // used only in the profile tab
  String? userName;
  String userNickname = "";
  // used only in the group tab
  List<GroupResponse> _groups = [];
  GroupResponse? currentGroup;
  String? groupCode;
  String? groupQr;
  List<UserResponse> members = [];
  List<GameResponse> games = [];
  // used in dialogs
  String createGroupName = "";
  String createGameName = "";
  String createGameDesc = "";

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  /// call the server to get everything needed to display the page
  getData() async {
    // show all the spinners!
    this.profileIsLoading = true;
    this.groupsAreLoading = true;
    this.membersAreLoading = true;
    this.gamesAreLoading = true;

    // get user profile data
    await _getProfileData();

    // handle case where user isn't in a group
    // we will end up here if you leave the last group you're in
    if (this._user!.groups == null) {
      // TODO redirect to the create/join group page
      return;
    }

    // get all of the users groups
    await _getGroupData();

    // get the primary group id
    var primaryGroupId =
        await DeviceStorage.retrieveValue(storagePrimaryGroupId);
    onGroupSelected(primaryGroupId!);
  }

  /// called when the group drop down is changed
  onGroupSelected(String groupId) async {
    this.currentGroup =
        this._groups.firstWhere((group) => group.groupID == groupId);

    // set permissions
    this.isGroupOwner = this.currentGroup!.ownerID == this._user!.userID;

    // set the group code field
    this.groupCode = currentGroup!.code;

    // get the group's members
    await _getGroupMembers(groupId);

    // get the group's games
    await _getGameData(groupId);
  }

  /// called when the code is pressed so you can share it
  onShareGroupCodeClicked() async {
    // TODO show the share via screen
  }

  /// remove a member from the group
  onRemoveGroupMember(String userId) async {
    try {
      await Group.leave(this.currentGroup!.groupID, userId);
      var idx = this.members.indexWhere((user) => user.userID == userId);
      this.members.removeAt(idx);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// called when the show qr button is clicked
  onShowQrClicked() async {
    try {
      var qr = await Group.getQR(this.currentGroup!.groupID);
      this.groupQr = qr;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// called when the hide qr button is clicked
  onHideQrClicked() {
    this.groupQr = null;
  }

  /// show the create group popup
  onCreateGroupClicked() {
    this.createGroupVisible = true;
  }

  /// hide the create group popup
  onDismissCreateGroup() {
    this.createGroupVisible = false;
    this.createGroupName = "";
  }

  /// create the group
  onCreateGroupSubmit() async {
    // TODO validate form
    var requestData = CreateUpdateGroupRequest(this.createGroupName);
    try {
      // create the group
      var group = await Group.create(requestData);

      // hide the dialog and reset
      onDismissCreateGroup();

      // add the group to the view and select it
      this._groups.add(group);
      onGroupSelected(group.groupID);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// leave the currently selected group and reload the page data
  onLeaveGroupClicked() async {
    try {
      // leave the group
      await Group.leave(this.currentGroup!.groupID, this._user!.userID);
      // reload the page data
      this.getData();
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// show the create game popup
  onCreateGameClicked() {
    this.createGameVisible = true;
  }

  /// hide the create game popup
  onDismissCreateGame() {
    this.createGameVisible = false;
    this.createGameName = "";
    this.createGameDesc = "";
  }

  /// create the game
  onCreateGameSubmit() async {
    // TODO validate form
    var requestData =
        CreateUpdateGameRequest(this.createGameName, this.createGameDesc);
    try {
      // create the game
      var game = await Game.create(this.currentGroup!.groupID, requestData);

      // hide the dialog and reset
      onDismissCreateGame();

      // add the game to the view
      this.games.add(game);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// remove a game from the group
  onDeleteGameClicked(String gameId) async {
    try {
      await Game.delete(this.currentGroup!.groupID, gameId);
      var idx = this.games.indexWhere((game) => game.gameID == gameId);
      this.games.removeAt(idx);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// call the server to get the user's profile data
  _getProfileData() async {
    try {
      // retrieve the user id from the stored token
      var tkn = await Token.get();
      var user = await User.get(tkn.sub, withVotes: false);
      // set the vars
      this._user = user;
      this.userName = user.name;
      this.userNickname = user.nickName == null ? "" : user.nickName!;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
    this.profileIsLoading = false;
  }

  /// call the server to get every group the user is a member of
  _getGroupData() async {
    // get every group the the user is a member of
    for (var groupId in _user!.groups!) {
      try {
        // add the group to the list
        var group = await Group.get(groupId);
        _groups.add(group);
        // we can show the drop down once the first group is added
        this.groupsAreLoading = false;
      } catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err as ProblemResponse);
      }
    }
    this.groupsAreLoading = false;
  }

  /// get all the games for a group
  _getGameData(String groupId) async {
    this.gamesAreLoading = true;
    try {
      var response = await Group.getGames(groupId);
      this.games = response.games;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
    this.gamesAreLoading = false;
  }

  /// get the members of a group
  _getGroupMembers(String groupId) async {
    this.membersAreLoading = true;
    try {
      var response = await Group.getMembers(groupId, withVotes: false);
      this.members = response.members;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
    membersAreLoading = false;
  }
}
