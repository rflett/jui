import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:intl/intl.dart';

class ViewUserPopup extends StatefulWidget {
  final UserResponse user;
  final bool isGroupOwner;
  final bool canRemoveUser;
  final bool canPromoteUser;
  final void Function() onRemoved;
  final void Function() onUpdateOwner;

  ViewUserPopup(
      {Key? key,
      required this.user,
      required this.canRemoveUser,
      required this.isGroupOwner,
      required this.canPromoteUser,
      required this.onRemoved,
      required this.onUpdateOwner})
      : super(key: key);

  @override
  _ViewUserPopupState createState() => _ViewUserPopupState(
        this.user,
        this.isGroupOwner,
        this.canRemoveUser,
        this.canPromoteUser,
        this.onRemoved,
        this.onUpdateOwner,
      );
}

class _ViewUserPopupState extends State<ViewUserPopup> {
  // properties of the user being viewed
  late UserResponse _user;
  bool _isGroupOwner = false;
  // properties of the currently logged in user
  bool _canRemoveUser = false;
  bool _canPromoteUser = false;
  // callbacks
  late void Function() _removeMemberCallback;
  late void Function() _updateGroupOwnerCallback;

  _ViewUserPopupState(
    UserResponse user,
    bool isGroupOwner,
    bool canRemoveUser,
    bool canPromoteUser,
    Function() onRemoved,
    Function() onUpdateOwner,
  ) {
    this._user = user;
    this._isGroupOwner = isGroupOwner;
    this._canRemoveUser = canRemoveUser;
    this._canPromoteUser = canPromoteUser;
    this._removeMemberCallback = onRemoved;
    this._updateGroupOwnerCallback = onUpdateOwner;
  }

  void _removeMember(BuildContext context) {
    Navigator.of(context).pop(true);
    this._removeMemberCallback();
  }

  void _updateGroupOwner(BuildContext context) {
    Navigator.of(context).pop(true);
    this._updateGroupOwnerCallback();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this._user.name),
      contentPadding: EdgeInsets.fromLTRB(20, 20, 20, 10),
      actionsPadding: EdgeInsets.fromLTRB(10, 0, 10, 0),
      content: Container(
        width: 200,
        height: this._canPromoteUser == true ? 250 : 200,
        child: ListView(
          children: [
            Card(
              child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.person_outline_rounded),
                  title: Text("Nickname"),
                  subtitle: Text(this._user.nickName!)),
            ),
            Card(
              child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.calendar_today_outlined),
                  title: Text("Date Joined"),
                  subtitle:
                      Text(DateFormat.yMMMd().format(this._user.createdAt))),
            ),
            Card(
              child: ListTile(
                  dense: true,
                  visualDensity: VisualDensity.compact,
                  leading: Icon(Icons.star_rounded),
                  title: Text("Group Owner"),
                  subtitle: Text(this._isGroupOwner == true ? "Yes" : "No")),
            ),
            SizedBox(height: 10),
            Visibility(
              visible: this._canPromoteUser,
              child: ElevatedButton(
                child: Text("PROMOTE TO GROUP OWNER"),
                onPressed: () => _updateGroupOwner(context),
              ),
            ),
          ],
        ),
      ),
      actions: [
        Visibility(
          visible: this._canRemoveUser,
          child: IconButton(
            alignment: Alignment.centerLeft,
            icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
            onPressed: () => this._removeMember(context),
          ),
        ),
        TextButton(
          child: Text('Close'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
