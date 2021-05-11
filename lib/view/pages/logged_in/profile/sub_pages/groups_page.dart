import 'package:flutter/material.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/view/pages/logged_in/components/share_group_code.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/group_dropdown.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/qr_widget.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/view_user_popup.dart';

class GroupsPage extends StatefulWidget {
  final UserResponse user;
  final List<GroupResponse> groups;

  GroupsPage({Key? key, required this.user, required this.groups})
      : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState(user, groups);
}

class _GroupsPageState extends State<GroupsPage> {
  // id of the currently selected group from the drop down
  String? _selectedGroupId;
  // members of the currently selected group
  List<UserResponse> _selectedGroupMembers = [];
  // code of the currently selected group
  String _selectedGroupCode = "";
  // the current logged in user
  UserResponse? _user;
  // all groups that a user is a member of
  List<GroupResponse> _groups = [];

  _GroupsPageState(UserResponse user, List<GroupResponse> groups) {
    this._user = user;
    this._groups = groups;
  }

  /// called when a group is selected from the drop down, updates the page data
  void _selectGroup(String? groupId) async {
    var group = await Group.getMembers(groupId!, withVotes: false);
    setState(() {
      this._selectedGroupId = groupId;
      this._selectedGroupCode = this
          ._groups
          .firstWhere((group) => group.groupID == this._selectedGroupId)
          .code;
      this._selectedGroupMembers = group.members;
    });
  }

  /// returns whether leave icon should be disabled
  bool get _canLeaveCurrentGroup {
    return !(this._user == null || this._user!.groups!.length == 1);
  }

  /// removes the current user from the group
  void _leaveCurrentGroup() async {
    try {
      if (this._user!.groups!.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can't leave your last group.")),
        );
        return;
      }

      if (this._userIsGroupOwner(this._user!.userID)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("TODO prompt to neknominate a new owner.")),
        );
        return;
      }

      // leave the group
      var groupToLeave = this._selectedGroupId!;
      await Group.leave(groupToLeave, this._user!.userID);

      // remove group from lists, we could get the data again but that's slow af
      setState(() {
        this._groups.removeWhere((group) => group.groupID == groupToLeave);
        this._user!.groups!.removeWhere((groupId) => groupId == groupToLeave);
      });

      // update the primary group id if you just left it
      var primaryGroupId =
          await DeviceStorage.retrieveValue(storagePrimaryGroupId);
      if (primaryGroupId == groupToLeave) {
        await DeviceStorage.storeValue(
            storagePrimaryGroupId, this._user!.groups![0]);
      }

      // select the primary
      this._selectGroup(primaryGroupId);

      // let the user know we're gucci
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You have left the group.")),
      );
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// displays the group QR code
  void _onShowQR() {
    if (_selectedGroupId != null) {
      showDialog(
          context: context,
          builder: (context) {
            return QrWidget(qrContent: this._selectedGroupCode);
          });
    }
  }

  /// returns whether the member is the owner of the selected group
  bool _userIsGroupOwner(String userId) {
    return this
            ._groups
            .firstWhere((group) => group.groupID == this._selectedGroupId)
            .ownerID ==
        userId;
  }

  void _confirmRemoveMember(String userId, String name) async {
    var shouldRemove = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm"),
            content:
                Text("Are you sure you want to remove $name from the group?"),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (shouldRemove == true) {
      _removeMember(userId, name);
    }
  }

  /// removes a member from the group
  void _removeMember(String userId, String name) async {
    /**
     * This shouldn't be reachable. The remove member button should always be
     * hidden for yourself.
     */
    if (userId == this._user!.userID) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("You can't leave using this button!")),
      );
      return;
    }

    // removing any other member from the group
    try {
      await Group.leave(this._selectedGroupId!, userId);
      setState(() {
        this._selectedGroupMembers.removeWhere((user) => user.userID == userId);
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("Successfully removed $name from the group.")));
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void _showUser(UserResponse user) async {
    showDialog(
      context: context,
      builder: (context) {
        return ViewUserPopup(
          user: user,
          canRemoveUser: this._userIsGroupOwner(this._user!.userID) &&
              this._user!.userID != user.userID,
          isGroupOwner: this._userIsGroupOwner(user.userID),
        );
      },
    );
  }

  Widget groupMembers(BuildContext context) {
    List<Widget> listItems = [];

    for (var i = 0; i < this._selectedGroupMembers.length; i++) {
      var thisUserId = this._selectedGroupMembers[i].userID;
      listItems.add(Container(
        child: Card(
          child: ListTile(
            leading: UserAvatar(
              uuid: (this._user == null ? "" : this._user!.userID),
              size: 30,
            ),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: "${this._selectedGroupMembers[i].name} ",
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  WidgetSpan(
                    /// show a star next to the group owner's name
                    child: this._userIsGroupOwner(thisUserId)
                        ? Icon(Icons.star_rounded, size: 18)
                        : Container(),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.info_outline_rounded, color: Colors.black),
              onPressed: () => this._showUser(this._selectedGroupMembers[i]),
            ),
          ),
        ),
      ));
    }

    return SizedBox(height: 400, child: ListView(children: listItems));
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(
          Size(300, 600),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                GroupDropDown(
                  groups: this._groups,
                  onGroupSelected: (groupId) => this._selectGroup(groupId),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(
                    Icons.exit_to_app_rounded,
                    color:
                        this._canLeaveCurrentGroup ? Colors.red : Colors.grey,
                  ),
                  onPressed: this._canLeaveCurrentGroup
                      ? () => this._leaveCurrentGroup()
                      : null,
                ),
              ],
            ),
            Divider(),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Stack(children: [
                    ShareGroupCode(code: this._selectedGroupCode),
                  ]),
                ),
                SizedBox(width: 20),
                TextButton(
                  child: Text("SHOW QR"),
                  onPressed: _onShowQR,
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 10),
            Divider(),
            groupMembers(context)
          ],
        ),
      ),
    );
  }
}
