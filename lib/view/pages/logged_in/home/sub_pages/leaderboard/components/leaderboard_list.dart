import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/state/group_state.dart';
import 'package:provider/provider.dart';

import 'leaderboard_card/leaderboard_card.dart';
import 'leaderboard_card_skeleton.dart';

class LeaderboardList extends StatelessWidget {
  final bool showVotes;

  const LeaderboardList({required this.showVotes, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<GroupState>(
      builder: (context, groupState, child) {
        if (groupState.members.length > 0) {
          return showLeaderboard(groupState);
        } else {
          return showSkeletons();
        }
      },
    );
  }

  Widget showLeaderboard(GroupState groupState) {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) =>
            renderCard(context, index, groupState),
        separatorBuilder: (context, index) => SizedBox(height: 60),
        itemCount: groupState.members.length,
      ),
    );
  }

  Widget showSkeletons() {
    return Expanded(
      child: ListView.separated(
        itemBuilder: (BuildContext context, int index) =>
            LeaderboardCardSkeleton(),
        separatorBuilder: (context, index) => SizedBox(height: 60),
        itemCount: 3,
      ),
    );
  }

  Widget renderCard(BuildContext context, int index, GroupState groupState) {
    UserResponse user = groupState.members[index];
    return LeaderboardCard(position: ++index, user: user);
  }
}
