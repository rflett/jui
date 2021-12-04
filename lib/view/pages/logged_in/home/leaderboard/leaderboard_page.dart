import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/home/leaderboard/components/leaderboard_list.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool _showVotes = false;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FractionallySizedBox(
        widthFactor: 0.9,
        child: Column(children: [
          SizedBox(height: 20),
          LeaderboardList(showVotes: _showVotes)
        ]),
      ),
    );
  }
}
