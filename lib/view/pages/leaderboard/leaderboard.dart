import 'package:flutter/material.dart';
import 'package:jui/view/pages/leaderboard/components/leaderboard_card.dart';

class Leaderboard extends StatefulWidget {
  Leaderboard({Key? key}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState();
}

class _LeaderboardState extends State<Leaderboard> {
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
          child: ListView.separated(
            itemBuilder: renderCard,
            separatorBuilder: (context, index) => Padding(
              padding: EdgeInsets.symmetric(vertical: 30),
            ),
            itemCount: users.length,
          ),
        ),
      ),
    );
  }

  Widget renderCard(BuildContext context, int index) {
    String name = users[index];
    return LeaderboardCard(name, ++index);
  }
}
