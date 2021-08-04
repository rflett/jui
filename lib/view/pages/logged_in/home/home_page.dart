import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/leaderboard/leaderboard_page.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/my_votes_page.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/played_songs/played_songs_page.dart';

class HomePage extends StatefulWidget {
  final List<UserResponse> members;

  HomePage({Key? key, required this.members}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState(members);
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  _HomePageState(List<UserResponse> members) {
    this._pages = [
      Leaderboard(members: members),
      PlayedSongsPage(),
      MyVotesPage()
    ];
  }

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
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_rounded), label: "Leaderboard"),
          BottomNavigationBarItem(icon: Icon(Icons.history_rounded), label: "Played Songs"),
          BottomNavigationBarItem(icon: Icon(Icons.music_note_outlined), label: "My Votes"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey.shade300.withAlpha(150),
        onTap: _onItemTapped,
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
    );
  }
}