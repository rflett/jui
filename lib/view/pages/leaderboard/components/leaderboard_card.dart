import 'package:flutter/material.dart';

class LeaderboardCard extends StatelessWidget {
  int position;
  String user;

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
            child: Container(
              height: 120,
              width: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                boxShadow: [BoxShadow(blurRadius: 2, spreadRadius: 0.1)],
                image: DecorationImage(
                  fit: BoxFit.fill,
                  image: NetworkImage(
                    "https://www.thispersondoesnotexist.com/image?value=${this.user}",
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
