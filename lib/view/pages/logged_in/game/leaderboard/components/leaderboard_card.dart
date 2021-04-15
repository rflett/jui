import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class LeaderboardCard extends StatelessWidget {
  final int position;
  final String user;

  LeaderboardCard(this.user, this.position);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        children: [
          Positioned(
            child: Card(
              color: Colors.white,
              margin: EdgeInsets.only(left: 60),
              child: Padding(
                padding: EdgeInsets.fromLTRB(70, 20, 20, 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(
                        "#${this.position.toString()}",
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        user,
                        style: TextStyle(
                            fontSize: 30, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            top: 15,
            child: UserAvatar(uuid: this.user),
          )
        ],
      ),
    );
  }
}
