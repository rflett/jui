import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class LeaderboardCardVotes extends StatelessWidget {
  final bool isExpanded;
  final List<Vote> votes;
  final String Function(int points) pointsToHuman;

  const LeaderboardCardVotes(
      {Key? key,
      required this.isExpanded,
      required this.votes,
      required this.pointsToHuman})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isExpanded ? null : 0,
      duration: Duration(milliseconds: 150),
      child: Column(children: [
        SizedBox(height: 20),
        ...this.votes.map(
              (value) => SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      value.name,
                      style: TextStyle(
                        fontWeight: value.playedAt != null
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                    Spacer(),
                    if (value.playedAt != null)
                      Text(this.pointsToHuman(100 - value.playedPosition!)),
                  ],
                ),
              ),
            ),
      ]),
    );
  }
}
