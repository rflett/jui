import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class LeaderboardCard extends StatelessWidget {
  final bool isExpanded;
  final int position;
  final String user;

  LeaderboardCard(this.isExpanded, this.user, this.position);

  final Map<String, int?> _votes = {
    "1. Better Man - Alice Ivy": 80,
    "2. Move - Baker Boy": null,
    "3. Kool - Benee": 10,
    "4. Better Man": 5,
    "5. Better Man - Alice Ivy": 80,
    "6. Move - Baker Boy": null,
    "7. Kool - Benee": 10,
    "8. Better Man - Alice Ivy": 80,
    "9. Move - Baker Boy": null,
    "10. Kool - Benee": 10,
  };

  String posToHuman() {
    if (this.position == 1) {
      return "1st";
    }
    if (this.position == 2) {
      return "2nd";
    }
    if (this.position == 3) {
      return "3rd";
    }

    // Otherwise match rest
    return "${position}th";
  }

  // padding: EdgeInsets.fromLTRB(70, 0, 20, 20),
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: isExpanded? 450 : 120,
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
                        UserAvatar(uuid: this.user, size: 80),
                        SizedBox(width: 10),
                        Expanded(
                          child: ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              user,
                              style: TextStyle(
                                  fontSize: 25, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text(
                              "15 points",
                              style: TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
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
                ..._votes.entries.map(
                  (value) => SizedBox(
                    height: 30,
                    child: Row(
                      children: [
                        Text(
                          value.key,
                          style: TextStyle(
                            fontWeight: value.value != null
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        Spacer(),
                        if (value.value != null) Text("${value.value} pts"),
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
