import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/groups_page.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/my_profile_page.dart';

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 0;
  List<Widget> _profilePages = [
    MyProfilePage(),
    GroupsPage(),
    Text("I'm the games Page"),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Theme.of(context).primaryColor,
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.person_outline_rounded), label: "My Profile"),
          BottomNavigationBarItem(icon: Icon(Icons.people_alt_outlined), label: "Groups"),
          BottomNavigationBarItem(icon: Icon(Icons.local_play_outlined), label: "Games"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300.withAlpha(150),
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _profilePages.elementAt(_selectedIndex),
      ),
    );
  }
}
