import 'package:flutter/material.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/utilities/token.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/qr_widget.dart';
import 'package:share/share.dart';

class GroupsPage extends StatefulWidget {
  GroupsPage({Key? key}) : super(key: key);

  @override
  _GroupsPageState createState() => _GroupsPageState();
}

class _GroupsPageState extends State<GroupsPage> {
  // drop down menu item for selecting the current group
  List<DropdownMenuItem<String>> _selectedGroupOptions = [];
  // id of the currently selected group from the drop down
  String? _selectedGroupId;
  // members of the currently selected group
  List<UserResponse> _selectedGroupMembers = [];
  // code of the currently selected group
  TextEditingController _selectedGroupCodeController =
      new TextEditingController(text: '');
  // the current logged in user
  UserResponse? user;
  // all groups that a user is a member of
  List<GroupResponse> _groups = [];

  _GroupsPageState() {
    this._getData();
  }

  @override
  void dispose() {
    _selectedGroupCodeController.dispose();
    super.dispose();
  }

  /// load all the data required on first visit to the page
  _getData() async {
    try {
      // retrieve the user id from the stored token
      var tkn = await Token.get();
      var user = await User.get(tkn.sub, withVotes: false);
      this.user = user;

      // get all the users groups
      // TODO this should be 1 API call
      List<GroupResponse> groups = [];
      for (var i = 0; i < this.user!.groups!.length; i++) {
        var group = await this.getGroup(this.user!.groups![i]);
        if (group != null) {
          groups.add(group);
        }
      }
      this._groups = groups;

      // generate the drop down items and select the first group in the list
      _generateDropDownItems();
      this._selectGroup(this._groups[0].groupID);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// generates the group drop down menu items from the users groups
  void _generateDropDownItems() {
    this._selectedGroupOptions = this
        ._groups
        .map((element) => DropdownMenuItem<String>(
            value: element.groupID, child: Text(element.name)))
        .toList();
  }

  /// called when a group is selected from the drop down, updates the page data
  void _selectGroup(String? groupId) async {
    var group = await Group.getMembers(groupId!, withVotes: false);
    setState(() {
      this._selectedGroupId = groupId;
      this._selectedGroupCodeController.text = this
          ._groups
          .firstWhere((group) => group.groupID == this._selectedGroupId)
          .code;
      this._selectedGroupMembers = group.members;
    });
  }

  /// returns whether leave icon should be disabled
  bool get _canLeaveCurrentGroup {
    return !(this.user == null || this.user!.groups!.length == 1);
  }

  /// removes the current user from the group
  void _leaveCurrentGroup() async {
    try {
      if (this.user!.groups!.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You can't leave your last group.")),
        );
        return;
      }

      if (this._userIsGroupOwner(this.user!.userID)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("TODO prompt to neknominate a new owner.")),
        );
        return;
      }

      // leave the group
      var groupToLeave = this._selectedGroupId!;
      await Group.leave(groupToLeave, this.user!.userID);

      // remove group from lists, we could get the data again but that's slow af
      setState(() {
        this._groups.removeWhere((group) => group.groupID == groupToLeave);
        this.user!.groups!.removeWhere((groupId) => groupId == groupToLeave);
        this._generateDropDownItems();
      });

      // update the primary group id if you just left it
      var primaryGroupId =
          await DeviceStorage.retrieveValue(storagePrimaryGroupId);
      if (primaryGroupId == groupToLeave) {
        await DeviceStorage.storeValue(
            storagePrimaryGroupId, this.user!.groups![0]);
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

  /// called when the share invite code button is pressed
  void _onShare() {
    var shareUrl =
        "Vote and compete in the Hottest 100 with me on JUI! https://jaypi.online/join/${this._selectedGroupCodeController.text}";
    Share.share(shareUrl);
  }

  /// displays the group QR code
  void _onShowQR() {
    if (_selectedGroupId != null) {
      showDialog(
          context: context,
          builder: (context) {
            return QrWidget(qrContent: this._selectedGroupCodeController.text);
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
    if (userId == this.user!.userID) {
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

  Future<GroupResponse?> getGroup(String groupId) async {
    try {
      var group = await Group.get(groupId);
      return group;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  Widget groupMembers(BuildContext context) {
    List<Widget> listItems = [];

    for (var i = 0; i < this._selectedGroupMembers.length; i++) {
      var thisUserId = this._selectedGroupMembers[i].userID;
      listItems.add(Container(
        child: Card(
          child: ListTile(
              leading: UserAvatar(
                uuid: (this.user == null ? "" : this.user!.userID),
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
              trailing: Visibility(
                visible: this._userIsGroupOwner(this.user!.userID) &&
                    this.user!.userID != thisUserId,
                child: IconButton(
                  icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
                  onPressed: () => _confirmRemoveMember(
                    thisUserId,
                    this._selectedGroupMembers[i].name,
                  ),
                ),
              )),
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
                DropdownButton(
                  value: _selectedGroupId,
                  onChanged: (String? newValue) => _selectGroup(newValue),
                  items: _selectedGroupOptions,
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
                    TextField(
                      controller: _selectedGroupCodeController,
                      decoration: InputDecoration(
                          suffixIcon: IconButton(
                            icon: Icon(Icons.share_rounded),
                            onPressed: _onShare,
                          ),
                          labelText: "Invite Code",
                          isDense: true,
                          border: OutlineInputBorder()),
                    ),
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
