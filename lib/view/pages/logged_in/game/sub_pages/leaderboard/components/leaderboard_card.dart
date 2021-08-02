import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class LeaderboardCard extends StatelessWidget {
  final bool isExpanded;
  final int position;
  final UserResponse user;
  List<Vote> _votes = [];

  LeaderboardCard(this.isExpanded, this.user, this.position) {
    this._votes = user.votes == null ? [] : user.votes!;
  }

  String posToHuman() {
    var x = this.position % 10;
    var y = this.position % 100;

    if (x == 1 && y != 11) {
      return "${this.position}st";
    }
    if (x == 2 && y != 12) {
      return "${this.position}nd";
    }
    if (x == 3 && y != 13) {
      return "${this.position}rd";
    }
    return "${position}th";
  }

  String pointsToHuman(int points) {
    String suffix;
    if (points == 1) {
      suffix = "point";
    } else {
      suffix = "points";
    }
    return "${this.user.points} $suffix";
  }

  // padding: EdgeInsets.fromLTRB(70, 0, 20, 20),
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isExpanded ? 450 : 120,
      curve: Curves.easeInOut,
      duration: Duration(milliseconds: 400),
      child: ClipRect(
        child: Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                SizedBox(
                  height: 80,
                  child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        UserAvatar(uuid: this.user.userID, size: 80),
                        SizedBox(width: 10),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              this.user.name,
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              pointsToHuman(this.user.points),
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.normal),
                            ),
                          ),
                        ),
                        Spacer(),
                        Expanded(
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ListTile(
                              title: Text(
                                posToHuman(),
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          ),
                        ),
                      ]),
                ),
                SizedBox(height: 20),
                ...this._votes.map(
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
                              Text(this
                                  .pointsToHuman(100 - value.playedPosition!)),
                          ],
                        ),
                      ),
                    ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
