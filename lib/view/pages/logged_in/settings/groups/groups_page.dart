import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/group/update_group_owner.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/state/user_state.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/pages/logged_in/components/group_dropdown.dart';
import 'package:jui/view/pages/logged_in/components/share_group_code.dart';
import 'package:jui/view/pages/logged_in/settings/components/create_update_group.dart';
import 'package:jui/view/pages/logged_in/settings/components/qr_widget.dart';
import 'package:jui/view/pages/logged_in/settings/components/view_user_popup.dart';
import 'package:jui/view/pages/logged_in/settings/groups/components/group_member_list.dart';
import 'package:provider/provider.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  /// returns whether leave button should be disabled

  /// displays the group QR code
  void _onShowQR(String? groupCode) {
    if (groupCode != null) {
      showDialog(
        context: context,
        builder: (context) {
          return QrWidget(qrContent: groupCode);
        },
      );
    }
  }

  bool _canLeaveCurrentGroup(UserResponse? currentUser) {
    if (currentUser != null) {
      return currentUser.groups!.length != 1;
    }
    return false;
  }

  void _confirmLeaveGroup(
      UserResponse? currentUser, GroupState groupState) async {
    if (currentUser == null || groupState.selectedGroup == null) {
      return;
    }
    GroupResponse selectedGroup = groupState.selectedGroup!;

    /// prompt and tell the user to nominate a new owner if they are already
    /// the group owner and there's other members in the group
    if (currentUser.isOwnerOf(selectedGroup) && groupState.members.length > 1) {
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

    final shouldDelete = await showDialog<bool>(
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

    if (shouldDelete == true) {
      this._deleteGroup(selectedGroup.groupID, selectedGroup.name);
    }
  }

  void _confirmRemoveMember(UserResponse user, UserResponse currentUser,
      GroupResponse currentGroup) async {
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
      _removeMember(user.userID, currentGroup.groupID, user.name);
    } else {
      _showUser(user, currentUser, currentGroup);
    }
  }

  /// Removes a member from the group
  void _removeMember(String userId, String groupId, String? name) async {
    try {
      await Group.leave(groupId, userId);
      if (name != null) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text("Successfully removed $name from the group.")));
      }
      // TODO update the group list for the current user
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void _updateGroupOwner(UserResponse user, UserResponse currentUser,
      GroupResponse currentGroup) async {
    var shouldUpdate = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm"),
            content: Text(
              "Are you sure you want to make ${user.name} the new group owner? \n"
              "They will now manage the group and its members.",
            ),
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

    if (shouldUpdate == true) {
      updateGroupOwner(user.userID, currentGroup.groupID);
    } else {
      _showUser(user, currentUser, currentGroup);
    }
  }

  /// updates the group with a new owner
  void updateGroupOwner(String userId, String groupId) async {
    var requestData = UpdateGroupOwnerRequest(groupId, userId);

    try {
      await Group.updateOwner(requestData);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Successfully nominated a new owner.")));

      // TODO UPDATE THE GROUP LIST

    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// removes a member from the group
  void _deleteGroup(String groupId, String name) async {
    try {
      await Group.delete(groupId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully deleted $name.")));

      // TODO UPDATE THE GROUP LIST

    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// displays an alert dialog with information about the user
  void _showUser(UserResponse infoUser, UserResponse currentUser,
      GroupResponse currentGroup) async {
    var currentUserId = currentUser.userID;
    var isGroupOwner = infoUser.isOwnerOf(currentGroup);

    // can the logged in user remove this user?
    bool canRemoveUser = false;
    if (isGroupOwner && currentUserId != infoUser.userID) {
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
          user: infoUser,
          canRemoveUser: canRemoveUser,
          isGroupOwner: isGroupOwner,
          canPromoteUser: canPromoteUser,
          onRemoved: () =>
              {this._confirmRemoveMember(infoUser, currentUser, currentGroup)},
          onUpdateOwner: () =>
              {this._updateGroupOwner(infoUser, currentUser, currentGroup)},
        );
      },
    );
  }

  /// displays an alert dialog to edit the group
  void _editGroup(GroupResponse? currentGroup) {
    if (currentGroup != null) {
      showDialog(
        context: context,
        builder: (context) {
          return CreateUpdateGroupPopup(group: currentGroup);
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final userState = Provider.of<UserState>(context);
    final groupState = Provider.of<GroupState>(context);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Flex(
          direction: Axis.vertical,
          children: [
            GroupDropdown(
                hideUnderline: true,
                fontSize: 20,
                groups: groupState.groups,
                onGroupSelected: groupState.setSelectedGroupById,
                selectedId: groupState.selectedGroup?.groupID),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  style: ButtonStyle(
                    foregroundColor: MaterialStateProperty.all<Color>(
                        this._canLeaveCurrentGroup(userState.user) == true
                            ? Colors.red
                            : Colors.grey),
                  ),
                  child: Text("LEAVE GROUP"),
                  onPressed: this._canLeaveCurrentGroup(userState.user)
                      ? () =>
                          this._confirmLeaveGroup(userState.user, groupState)
                      : null,
                ),
                Visibility(
                  visible:
                      userState.user?.isOwnerOf(groupState.selectedGroup) ??
                          false,
                  child: TextButton(
                    child: Text("EDIT GROUP"),
                    onPressed: () => this._editGroup(groupState.selectedGroup),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Stack(children: [
                    ShareGroupCode(code: groupState.selectedGroup?.code ?? ""),
                  ]),
                ),
                SizedBox(width: 20),
                TextButton(
                  child: Text("SHOW QR"),
                  onPressed: () => _onShowQR(groupState.selectedGroup?.code),
                  style: TextButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Expanded(
              child: GroupMemberList(
                members: groupState.members,
                selectedGroup: groupState.selectedGroup!,
                currentUser: userState.user!,
                showUser: _showUser,
              ),
            ),
          ],
        ),
      ),
    );
  }
}