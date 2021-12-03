import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class LeaderboardCardUser extends StatelessWidget {
  final UserResponse user;
  final int position;
  final String Function(int points) pointsToHuman;

  const LeaderboardCardUser(
      {Key? key,
      required this.user,
      required this.position,
      required this.pointsToHuman})
      : super(key: key);

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

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 80,
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        UserAvatar(uuid: this.user.userID, size: 80),
        SizedBox(width: 10),
        Expanded(
          child: ListTile(
            contentPadding: EdgeInsets.zero,
            title: Text(
              this.user.name,
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              pointsToHuman(this.user.points),
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.normal),
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
    );
  }
}
