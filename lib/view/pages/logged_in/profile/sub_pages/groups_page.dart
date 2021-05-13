import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/server/group.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/pages/logged_in/components/share_group_code.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_group.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/qr_widget.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/view_user_popup.dart';

class GroupsPage extends StatefulWidget {
  final UserResponse user;
  final GroupResponse group;

  GroupsPage({Key? key, required this.user, required this.group})
      : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState(user, group);
}

class _GroupsPageState extends State<GroupsPage> {
  // the current logged in user
  late UserResponse _user;
  // all groups that a user is a member of
  late GroupResponse _group;
  // service to publish events on
  late SettingsService _service;
  // members of the currently selected group
  List<UserResponse> _members = [];

  /// returns whether leave button should be disabled
  bool get _canLeaveCurrentGroup {
    return this._user.groups!.length != 1;
  }

  _GroupsPageState(UserResponse user, GroupResponse group) {
    this._user = user;
    this._group = group;
    this._service = SettingsService.getInstance();
    this._getData();
  }

  void _getData() async {
    var groupMembers =
        await Group.getMembers(this._group.groupID, withVotes: false);
    setState(() {
      this._members = groupMembers.members;
    });
  }

  /// displays the group QR code
  void _onShowQR() {
    showDialog(
      context: context,
      builder: (context) {
        return QrWidget(qrContent: this._group.code);
      },
    );
  }

  /// returns whether the member is the owner of the selected group
  bool _userIsGroupOwner(String userId) {
    return this._group.ownerID == userId;
  }

  void _confirmLeaveGroup() async {
    /// prompt and tell the user to nominate a new owner if they are already
    /// the group owner and there's other members in the group
    if (this._userIsGroupOwner(this._user.userID) && this._members.length > 1) {
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Nominate an owner"),
            content: Text(
                "You need to nominate a new group owner before you can leave this group."),
            actions: [
              TextButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        },
      );
      return;
    }

    var shouldLeave = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm"),
            content: Text(
                "Are you sure you want to leave this group? Since you're the only one left, it will be deleted."),
            actions: [
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('YES, DELETE IT'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (shouldLeave == true) {
      _removeMember(this._user.userID);
    }
  }

  void _confirmRemoveMember(UserResponse user) async {
    var shouldRemove = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm"),
            content: Text(
                "Are you sure you want to remove ${user.name} from the group?"),
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
      _removeMember(user.userID, user.name);
    } else {
      _showUser(user);
    }
  }

  /// removes a member from the group
  void _removeMember(String userId, [String? name]) async {
    try {
      await Group.leave(this._group.groupID, userId);
      if (name != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Successfully removed $name from the group.")));
      }
      if (this._user.userID == userId) {
        this._service.sendMessage(ProfileEvents.reloadGroups);
      } else {
        this._getData();
      }
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// displays an alert dialog with information about the user
  void _showUser(UserResponse user) async {
    var currentUser = this._user.userID;
    var isGroupOwner = this._userIsGroupOwner(user.userID);

    // can the logged in user remove this user?
    bool canRemoveUser = false;
    if (this._userIsGroupOwner(currentUser) && currentUser != user.userID) {
      canRemoveUser = true;
    }

    // can the logged in user promote this user?
    bool canPromoteUser = false;
    if (canRemoveUser == true && isGroupOwner == false) {
      canPromoteUser = true;
    }

    showDialog(
      context: context,
      builder: (context) {
        return ViewUserPopup(
          user: user,
          canRemoveUser: canRemoveUser,
          isGroupOwner: isGroupOwner,
          canPromoteUser: canPromoteUser,
          onRemoved: () => {this._confirmRemoveMember(user)},
        );
      },
    );
  }

  /// displays an alert dialog to edit the group
  void _editGroup() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateUpdateGroupPopup(group: this._group);
      },
    );
  }

  Widget groupMembers(BuildContext context) {
    List<Widget> listItems = [];

    for (var i = 0; i < this._members.length; i++) {
      var thisUserId = this._members[i].userID;
      listItems.add(Container(
        child: Card(
          child: ListTile(
            leading: UserAvatar(uuid: (this._user.userID), size: 30),
            title: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: this._members[i].name,
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),

                  /// show a star next to the group owner's name
                  WidgetSpan(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(5, 0, 0, 0),
                        child: this._userIsGroupOwner(thisUserId)
                            ? Icon(Icons.star_rounded, size: 18)
                            : Container()),
                  ),
                ],
              ),
            ),
            trailing: IconButton(
              icon: Icon(Icons.info_outline_rounded, color: Colors.black),
              onPressed: () => this._showUser(this._members[i]),
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
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                this._group.name,
                style: TextStyle(fontWeight: FontWeight.w400, fontSize: 20),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        this._canLeaveCurrentGroup == true
                            ? Colors.red
                            : Colors.grey),
                  ),
                  child: Text("LEAVE GROUP"),
                  onPressed: this._canLeaveCurrentGroup
                      ? () => this._confirmLeaveGroup()
                      : null,
                ),
                Visibility(
                  visible: this._userIsGroupOwner(this._user.userID),
                  child: TextButton(
                    child: Text("EDIT GROUP"),
                    onPressed: () => this._editGroup(),
                  ),
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
                    ShareGroupCode(code: this._group.code),
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
