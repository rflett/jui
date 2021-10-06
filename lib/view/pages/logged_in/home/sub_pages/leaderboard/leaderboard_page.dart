import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/leaderboard/components/leaderboard_card_skeleton.dart';
import 'package:provider/provider.dart';

import 'components/leaderboard_card.dart';

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
            // Expanded(
            //   child: Consumer<GroupState>(
            //     builder: (context, groupState, child) => ListView.separated(
            //       itemBuilder: (BuildContext context, int index) =>
            //           renderCard(context, index, groupState),
            //       separatorBuilder: (context, index) => Padding(
            //         padding: EdgeInsets.symmetric(vertical: 30),
            //       ),
            //       itemCount: groupState.members.length,
            //     ),
            //   ),
            // ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    LeaderboardCard(
                        _showVotes,
                        UserResponse(
                            "123fdf",
                            "Test user",
                            "Test user",
                            5,
                            DateTime.now(),
                            List.empty(),
                            "Test user",
                            "",
                            "",
                            "https://robohash.org/asdaasdfasdf322dc22",
                            List.empty(),
                            DateTime.now()),
                        1),
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                ),
                itemCount: 2,
              ),
            ),
            Expanded(
              child: ListView.separated(
                itemBuilder: (BuildContext context, int index) =>
                    LeaderboardCardSkeleton(),
                separatorBuilder: (context, index) => Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                ),
                itemCount: 2,
              ),
            ),
          ]),
        ),
      ),
    );
  }

  Widget renderCard(BuildContext context, int index, GroupState groupState) {
    UserResponse user = groupState.members[index];
    return LeaderboardCard(_showVotes, user, ++index);
  }
}
