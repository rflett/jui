import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class LeaderboardCardVotes extends StatelessWidget {
  final bool isExpanded;
  final List<Vote> votes;
  final String Function(int points) pointsToHuman;

  const LeaderboardCardVotes({
    Key? key,
    required this.isExpanded,
    required this.pointsToHuman,
    required this.votes,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isExpanded ? null : 0,
      duration: Duration(milliseconds: 150),
      child: Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15),
          child: ListView.builder(
            itemCount: votes.length,
            itemBuilder: (BuildContext context, int i) {
              var vote = votes[i];
              return SizedBox(
                height: 30,
                child: Row(
                  children: [
                    Text(
                      "${vote.rank}. ${vote.name}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: vote.playedAt != null
                            ? FontWeight.bold
                            : FontWeight.normal,
                        decoration: vote.playedAt != null
                            ? TextDecoration.lineThrough
                            : null,
                      ),
                    ),
                    Spacer(),
                    if (vote.playedAt != null)
                      Text(this.pointsToHuman(100 - vote.playedPosition!)),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
