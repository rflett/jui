import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jui/view/pages/logged_in/home/leaderboard/leaderboard_page.dart';
import 'package:jui/view/pages/logged_in/home/my_votes/my_votes_page.dart';
import 'package:jui/view/pages/logged_in/home/played_songs/played_songs_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;
  List<Widget> _pages = [];

  _HomePageState() {
    this._pages = [Leaderboard(), PlayedSongsPage(), MyVotesPage()];
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
        backgroundColor: Theme.of(context).colorScheme.primary,
        items: [
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.medal), label: "Leaderboard"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.solidMusic), label: "Played Songs"),
          BottomNavigationBarItem(
              icon: FaIcon(FontAwesomeIcons.pollH), label: "My Votes"),
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
