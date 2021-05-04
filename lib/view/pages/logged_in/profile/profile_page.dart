import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/groups_page.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/my_profile_page.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  bool _groupDialVisible = false;
  int _selectedIndex = 0;
  List<Widget> _profilePages = [
    MyProfilePage(),
    GroupsPage(),
    Text("I'm the games Page"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;

      // group dial is only visible on the group tab
      this._groupDialVisible = _selectedIndex == 1;
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
      floatingActionButton: buildSpeedDial(),
    );
  }

  SpeedDial buildSpeedDial() {
    return SpeedDial(
      /// both default to 16
      marginEnd: 18,
      marginBottom: 20,
      icon: Icons.add,
      activeIcon: Icons.close,
      buttonSize: 56.0,
      visible: this._groupDialVisible,
      closeManually: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.black,
      overlayOpacity: 0.5,
      tooltip: 'Create/Join group',
      heroTag: 'create-join-group-fab',
      backgroundColor: Colors.indigo,
      foregroundColor: Colors.white,
      elevation: 10.0,
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
}
