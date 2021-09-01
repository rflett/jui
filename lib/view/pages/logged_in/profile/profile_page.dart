import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_game.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_group.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/games_page.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/groups_page.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/my_profile_page.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // navigation
  ProfilePages _currentPage = ProfilePages.myProfile;
  Map<ProfilePages, Widget> _profilePages = {};

  _ProfilePageState() {
    this._profilePages = Map.fromEntries([
      MapEntry(
        ProfilePages.myProfile,
        MyProfilePage(),
      ),
      MapEntry(
        ProfilePages.myGroups,
        GroupsPage(),
      ),
      MapEntry(
        ProfilePages.myGames,
        GamesPage(),
      ),
    ]);
  }

  void _onNavIconTapped(int index) {
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

  void _createGamePressed(String? groupId) {
    if (groupId != null) {
      showDialog(
        context: context,
        builder: (context) {
          return CreateUpdateGamePopup(groupId: groupId);
        },
      );
    }
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

  Widget groupsPageFab() {
    return FloatingActionButton(
      onPressed: () => _createGroupPressed(),
      child: const Icon(Icons.add),
      backgroundColor: Colors.indigo,
    );
  }

  Widget gamesPageFab() {
    final selectedGroupId =
        Provider.of<GroupState>(context).selectedGroup?.groupID;
    return FloatingActionButton(
      onPressed: () => _createGamePressed(selectedGroupId),
      child: const Icon(Icons.add),
      backgroundColor: Colors.indigo,
    );
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
              icon: Icon(Icons.people_alt_outlined), label: "My Group"),
          BottomNavigationBarItem(
              icon: Icon(Icons.local_play_outlined), label: "Games"),
        ],
        currentIndex: this._currentPage.index,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300.withAlpha(150),
        onTap: _onNavIconTapped,
      ),
      body: Center(
          child: this._profilePages.length == 0
              ? null
              : this._profilePages[this._currentPage]),
      floatingActionButton: _currentFab(),
    );
  }
}
