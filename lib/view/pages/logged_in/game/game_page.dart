import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/view/pages/logged_in/game/sub_pages/leaderboard/leaderboard.dart';
import 'package:jui/view/pages/logged_in/game/sub_pages/my_votes/my_votes_page.dart';
import 'package:jui/view/pages/logged_in/game/sub_pages/played_songs/played_songs_page.dart';

class GamePage extends StatefulWidget {
  final List<UserResponse> members;

  GamePage({Key? key, required this.members}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState(members);
}

class _GamePageState extends State<GamePage> {
  int _selectedIndex = 0;
  List<Widget> _gamePages = [];

  _GamePageState(List<UserResponse> members) {
    this._gamePages = [
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
        child: _gamePages.elementAt(_selectedIndex),
      ),
    );
  }
}