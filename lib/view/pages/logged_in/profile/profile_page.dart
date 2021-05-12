import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jui/constants/settings_pages.dart';
import 'package:jui/models/auth_token.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/models/enums/social_providers.dart';
import 'package:jui/server/group.dart';
import 'package:jui/server/user.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/token.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_game.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_group.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/games_page.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/groups_page.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/my_profile_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // navigation
  ProfilePages _currentPage = ProfilePages.myProfile;
  Map<ProfilePages, Widget> _profilePages = {};

  // id of the currently selected group from the drop down
  String? _selectedGroupId;

  // listeners
  late SettingsService _service;
  late StreamSubscription _serviceStream;

  _ProfilePageState() {
    this._getData();
    this._service = SettingsService.getInstance();
    this._serviceStream = _service.messages.listen(onMessageReceived);
  }

  @override
  void dispose() {
    this._serviceStream.cancel();
    super.dispose();
  }

  void onMessageReceived(ProfileEvents event) {
    // From Singleton
    switch (event) {
      case ProfileEvents.reloadGroups:
        _reloadGroups();
        break;
      case ProfileEvents.reloadGames:
        _reloadGames();
        break;
      default:
        throw UnsupportedError(
            "WTF are you doing, do you know how dangerous that is?");
    }
  }

  _reloadGroups() async {
    var token = await Token.get();
    var user = await User.get(token.sub, withVotes: false);

    // get groups
    var groups = await this._getUsersGroups(user);
    this._profilePages[ProfilePages.myGroups] =
        GroupsPage(user: user, groups: groups);

    setState(() {
      this._profilePages = this._profilePages;
    });
  }

  _reloadGames() async {
    var token = await Token.get();
    var user = await User.get(token.sub, withVotes: false);

    // get groups
    var groups = await this._getUsersGroups(user);
    this._profilePages[ProfilePages.myGames] = GamesPage(
      groups: groups,
      onGroupSelected: (groupId) => this._selectGroup(groupId),
    );

    setState(() {
      this._profilePages = this._profilePages;
    });
  }

  _getData() async {
    try {
      // retrieve the user id from the stored token
      var token = await Token.get();
      var user = await User.get(token.sub, withVotes: false);
      var groups = await this._getUsersGroups(user);

      // set the vars
      setState(() {
        this._profilePages = Map.fromEntries([
          MapEntry(ProfilePages.myProfile, MyProfilePage(user: user)),
          MapEntry(
              ProfilePages.myGroups, GroupsPage(user: user, groups: groups)),
          MapEntry(
            ProfilePages.myGames,
            GamesPage(
              groups: groups,
              onGroupSelected: (groupId) => this._selectGroup(groupId),
            ),
          ),
        ]);
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// called when a group is selected from the drop down, updates the page data
  void _selectGroup(String? groupId) async {
    setState(() {
      this._selectedGroupId = groupId;
    });
  }

  Future<List<GroupResponse>> _getUsersGroups(UserResponse user) async {
    // get all the users groups
    // TODO this should be 1 API call
    List<GroupResponse> groups = [];
    for (var i = 0; i < user.groups!.length; i++) {
      var group = await this._getGroup(user.groups![i]);
      if (group != null) {
        groups.add(group);
      }
    }
    return groups;
  }

  Future<GroupResponse?> _getGroup(String groupId) async {
    try {
      var group = await Group.get(groupId);
      return group;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void _onItemTapped(int index) {
    ProfilePages currentPage;
    switch (index) {
      case 0:
        currentPage = ProfilePages.myProfile;
        break;
      case 1:
        currentPage = ProfilePages.myGroups;
        break;
      case 2:
        currentPage = ProfilePages.myGames;
        break;
      default:
        currentPage = ProfilePages.myProfile;
        break;
    }

    setState(() {
      this._currentPage = currentPage;
    });
  }

  void _createGroupPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateUpdateGroupPopup();
      },
    );
  }

  void _joinGroupPressed() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("TODO prompt to join a group.")));
  }

  void _createGamePressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateUpdateGamePopup(groupId: this._selectedGroupId!);
      },
    );
  }

  Widget? _currentFab() {
    switch (this._currentPage) {
      case ProfilePages.myProfile:
        return null;
      case ProfilePages.myGroups:
        return groupsPageFab();
      case ProfilePages.myGames:
        return gamesPageFab();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(
              icon: Icon(Icons.person_outline_rounded), label: "My Profile"),
          BottomNavigationBarItem(
              icon: Icon(Icons.people_alt_outlined), label: "Groups"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_play_outlined), label: "Games"),
        ],
        currentIndex: this._currentPage.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300.withAlpha(150),
        onTap: _onItemTapped,
      ),
      body: Center(
          child: this._profilePages.length == 0
              ? null
              : this._profilePages[this._currentPage]),
      // TODO when this is set to groupsPageFab() the fab doesn't rotate in from the center when you switch pages
      floatingActionButton: _currentFab(),
    );
  }

  SpeedDial groupsPageFab() {
    return SpeedDial(
      marginEnd: 16,
      marginBottom: 16,
      icon: Icons.add,
      activeIcon: Icons.close,
      buttonSize: 56.0,
      visible: this._currentPage == ProfilePages.myGroups,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Create/Join group',
      heroTag: 'create-join-group-fab',
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 6,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add),
          backgroundColor: Colors.indigoAccent,
          label: 'Create',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => _createGroupPressed(),
        ),
        SpeedDialChild(
          child: Icon(Icons.person_add_rounded),
          backgroundColor: Colors.indigoAccent,
          label: 'Join',
          labelStyle: TextStyle(fontSize: 18.0),
          onTap: () => _joinGroupPressed(),
        ),
      ],
    );
  }

  Widget gamesPageFab() {
    return FloatingActionButton(
      onPressed: () => _createGamePressed(),
      child: const Icon(Icons.add),
      backgroundColor: Colors.indigo,
    );
  }
}
