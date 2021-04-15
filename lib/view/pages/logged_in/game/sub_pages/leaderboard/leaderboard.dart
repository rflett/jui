import 'package:flutter/material.dart';

import 'components/leaderboard_card.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
  bool _showVotes = false;

  List<String> users = [
    "Roma",
    "Florry",
    "Gaven",
    "Celesta",
    "Ulick",
    "Laurie",
    "Crin",
    "Mike",
    "Allyson",
    "Olia",
  ];

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
            Expanded(
              child: ListView.separated(
                itemBuilder: renderCard,
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                ),
                itemCount: users.length,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget renderCard(BuildContext context, int index) {
    String name = users[index];
    return LeaderboardCard(_showVotes, name, ++index);
  }
}
