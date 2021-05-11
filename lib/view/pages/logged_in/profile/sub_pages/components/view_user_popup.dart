import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/user/user.dart';

class ViewUserPopup extends StatefulWidget {
  final UserResponse user;
  final bool canRemoveUser;
  final bool isGroupOwner;

  ViewUserPopup(
      {Key? key,
      required this.user,
      required this.canRemoveUser,
      required this.isGroupOwner})
      : super(key: key);

  @override
  _ViewUserPopupState createState() =>
      _ViewUserPopupState(this.user, this.canRemoveUser, this.isGroupOwner);
}

class _ViewUserPopupState extends State<ViewUserPopup> {
  UserResponse? _user;
  bool _canRemoveUser = false;
  bool _isGroupOwner = false;

  _ViewUserPopupState(
      UserResponse user, bool canRemoveUser, bool isGroupOwner) {
    this._user = user;
    this._canRemoveUser = canRemoveUser;
    this._isGroupOwner = isGroupOwner;
  }

  void _remove() {}
  void _promote() {}

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this._user!.name),
      content: Container(
        width: 200,
        height: 200,
        child: ListView(
          children: [
            Wrap(
              runSpacing: 10,
              children: [
                Text(this._user!.userID),
                Text(this._user!.nickName!),
                Text(this._user!.authProvider),
                Text(this._user!.createdAt.toString()),
                Text("IsGroupOwner: ${this._isGroupOwner}"),
                Visibility(
                    visible: this._isGroupOwner == false,
                    child: ElevatedButton(
                      child: Text("PROMOTE TO GROUP OWNER"),
                      onPressed: () => this._promote(),
                    )),
              ],
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
            onPressed: () => this._remove(),
          ),
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
      ],
    );
  }
}
