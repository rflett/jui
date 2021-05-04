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
  // TODO this should be shared with the profile page
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

  _getData() async {
    try {
      // retrieve the user id from the stored token
      var tkn = await Token.get();
      var user = await User.get(tkn.sub, withVotes: false);
      this.user = user;

      // get all the users groups
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
      this._groupSelected(this._groups[0].groupID);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  /// returns whether leave icons should be disabled as you only have 1 group
  bool _canLeave() {
    return !(this.user == null || this.user!.groups!.length == 1);
  }

  /// returns whether the user can remove themselves from the group from the list
  bool _canRemoveMember(String userId) {
    if (userId == this.user!.userID) {
      return this._canLeave();
    } else {
      return true;
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
  void _groupSelected(String? groupId) async {
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

  /// called when the share invite code button is pressed
  void _onSharePressed() {
    var shareUrl =
        "Vote and compete in the Hottest 100 with me on JUI! https://jaypi.online/join/${this._selectedGroupCodeController.text}";
    Share.share(shareUrl);
  }

  /// displays the group QR code
  void _showQrCode() {
    if (_selectedGroupId != null) {
      showDialog(
          context: context,
          builder: (context) {
            return QrWidget(qrContent: this._selectedGroupCodeController.text);
          });
    }
  }

  void _onRemoveMemberPressed(String userId, String name) async {
    var shouldRemove = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm"),
            content:
                Text("Are you sure you want to remove $name from your group?"),
            actions: [
              ElevatedButton(
                child: Text('NO'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                style: TextButton.styleFrom(primary: Colors.red),
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
    // removing yourself from the group using the members list
    if (userId == this.user!.userID) {
      this._leaveGroup(userId);
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

  /// removes the current user from the group
  void _leaveGroup(String userId) async {
    try {
      if (this.user!.groups!.length == 1) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("You can't leave your last group.")));
        return;
      }

      // leave the group
      var groupToLeave = this._selectedGroupId!;
      await Group.leave(groupToLeave, userId);

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
      this._groupSelected(primaryGroupId);

      // let the user know we're gucci
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("You have left the group.")));
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
      var thisUser = this._selectedGroupMembers[i].userID;
      listItems.add(Expanded(
        child: Card(
          child: ListTile(
            leading: FlutterLogo(), // TODO user profile pic
            title: Text(this._selectedGroupMembers[i].name),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline_rounded, color: _canRemoveMember(thisUser) ? Colors.red : Colors.grey),
              onPressed: () => !_canRemoveMember(thisUser) ? null : _onRemoveMemberPressed(
                this._selectedGroupMembers[i].userID,
                this._selectedGroupMembers[i].name,
              ),
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
                DropdownButton(
                  value: _selectedGroupId,
                  onChanged: (String? newValue) => _groupSelected(newValue),
                  items: _selectedGroupOptions,
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.exit_to_app_rounded,
                      color: this._canLeave() ? Colors.red : Colors.grey),
                  onPressed: this._canLeave()
                      ? () => _leaveGroup(this.user!.userID)
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
                            onPressed: _onSharePressed,
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
                  onPressed: _showQrCode,
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
