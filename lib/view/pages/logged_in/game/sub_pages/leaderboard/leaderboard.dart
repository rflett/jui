import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';

import 'components/leaderboard_card.dart';

class Leaderboard extends StatefulWidget {
  final List<UserResponse> members;

  Leaderboard({Key? key, required this.members}) : super(key: key);

  @override
  _LeaderboardState createState() => _LeaderboardState(members);
}

class _LeaderboardState extends State<Leaderboard> {
  bool _showVotes = false;

  List<UserResponse> _members = [];

  _LeaderboardState(List<UserResponse> members) {
    this._members = members;
  }

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
                itemCount: this._members.length,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget renderCard(BuildContext context, int index) {
    UserResponse user = this._members[index];
    return LeaderboardCard(_showVotes, user, ++index);
  }
}
