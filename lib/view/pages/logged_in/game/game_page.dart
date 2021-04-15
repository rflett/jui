import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/game/sub_pages/leaderboard/leaderboard.dart';

class GamePage extends StatefulWidget {
  GamePage({Key? key}) : super(key: key);

  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  int _selectedIndex = 0;
  List<Widget> _profilePages = [
    Leaderboard(),
    Leaderboard(),
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
          BottomNavigationBarItem(icon: Icon(Icons.favorite), label: "Leaderboard"),
          BottomNavigationBarItem(icon: Icon(Icons.search), label: "Played Songs"),
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