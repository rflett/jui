import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class GroupMemberList extends StatelessWidget {
  final UnmodifiableListView<UserResponse> members;
  final GroupResponse selectedGroup;
  final UserResponse currentUser;
  final void Function(UserResponse, UserResponse, GroupResponse) showUser;

  const GroupMemberList(
      {Key? key,
      required this.members,
      required this.selectedGroup,
      required this.currentUser,
      required this.showUser})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color? color = Theme.of(context).textTheme.bodyText1?.color;

    return ListView.separated(
        itemCount: members.length,
        separatorBuilder: (context, index) => SizedBox(height: 15),
        itemBuilder: (BuildContext context, int i) {
          return Container(
            child: Card(
              child: ListTile(
                leading: UserAvatar(uuid: currentUser.userID, size: 30),
                title: RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: members[i].name,
                        style: TextStyle(color: color, fontSize: 18),
                      ),

                      /// show a star next to the group owner's name
                      WidgetSpan(
                        child: Padding(
                            padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                            child: currentUser.isOwnerOf(selectedGroup)
                                ? Icon(Icons.star_rounded, size: 18)
                                : Container()),
                      ),
                    ],
                  ),
                ),
                trailing: IconButton(
                  icon: Icon(Icons.info_outline_rounded, color: color),
                  onPressed: () =>
                      this.showUser(members[i], currentUser, selectedGroup),
                ),
              ),
            ),
          );
        });
  }
}
