import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/state/group_state.dart';
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
    var data = Provider.of<GroupState>(context);
    var currentGroup = data.selectedGroup;
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
              child: Consumer<GroupState>(
                builder: (context, groupState, child) => ListView.separated(
                  itemBuilder: (BuildContext context, int index) =>
                      renderCard(context, index, groupState),
                  separatorBuilder: (context, index) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 30),
                  ),
                  itemCount: groupState.members.length,
                ),
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
