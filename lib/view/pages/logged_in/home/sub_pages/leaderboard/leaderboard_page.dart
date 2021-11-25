import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/leaderboard/components/leaderboard_list.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool _showVotes = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Center(
        child: FractionallySizedBox(
          widthFactor: 0.9,
          child: Column(children: [
            Align(
              alignment: Alignment.topRight,
              child: SizedBox(
                height: 50,
                width: 200,
                child: SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text("Show Votes"),
                    value: _showVotes,
                    onChanged: (val) => setState(() => _showVotes = val)),
              ),
            ),
            LeaderboardList(showVotes: _showVotes)
          ]),
        ),
      ),
    );
  }
}
