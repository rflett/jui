import 'package:flutter/material.dart';
import 'package:jui/constants/settings_pages.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_game.dart';
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
  int _selectedIndex = 0;
  bool _groupFabVisible = false;
  List<Widget> _profilePages = [
    MyProfilePage(),
    GroupsPage(),
    GamesPage(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
      _groupFabVisible = index == GroupSettingsPageIdx;
    });
  }

  void _createGroupPressed() {
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("TODO prompt to create a group.")));
  }

  void _joinGroupPressed() {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("TODO prompt to join a group.")));
  }

  void _createGamePressed() {
    showDialog(context: context, builder: (context) {
      return CreateUpdateGamePopup(groupId: "ad9c5208-e7f4-4fd8-bc03-305741f95a97");
    });
  }

  Widget? _currentFab() {
    switch (this._selectedIndex) {
      case ProfileSettingsPageIdx: {
        return null;
      }
      case GroupSettingsPageIdx: {
        return groupsPageFab();
      }
      case GamesSettingsPageIdx: {
        return gamesPageFab();
      }
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
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300.withAlpha(150),
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _profilePages.elementAt(_selectedIndex),
      ),
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
      visible: _groupFabVisible,
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
