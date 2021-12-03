import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/leaderboard/components/leaderboard_card/leaderboard_card_user.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/leaderboard/components/leaderboard_card/leaderboard_card_votes.dart';

class LeaderboardCard extends StatefulWidget {
  final int position;
  final UserResponse user;
  final List<Vote> _votes;

  LeaderboardCard({Key? key, required this.position, required this.user})
      : this._votes = user.votes ?? List.empty(),
        super(key: key);

  @override
  _LeaderboardCardState createState() => _LeaderboardCardState();
}

class _LeaderboardCardState extends State<LeaderboardCard> {
  bool isExpanded = false;

  void toggleExpansion() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  String pointsToHuman(int points) {
    String suffix;
    if (points == 1) {
      suffix = "point";
    } else {
      suffix = "points";
    }
    return "$points $suffix";
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: toggleExpansion,
      child: AnimatedContainer(
        height: isExpanded ? 450 : 120,
        curve: Curves.easeInOut,
        duration: Duration(milliseconds: 400),
        child: ClipRect(
          child: Card(
            color: Theme.of(context).cardColor,
            child: Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  LeaderboardCardUser(
                    user: widget.user,
                    position: widget.position,
                    pointsToHuman: pointsToHuman,
                  ),
                  LeaderboardCardVotes(
                    isExpanded: isExpanded,
                    votes: widget._votes,
                    pointsToHuman: pointsToHuman,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
