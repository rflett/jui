import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/user/update_user.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/token.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  UserResponse? _user;
  String _nickname = "";

  @override
  void initState() {
    super.initState();
    this._getProfileData();
  }

  _getProfileData() async {
    try {
      // retrieve the user id from the stored token
      var tkn = await Token.get();
      var user = await User.get(tkn.sub, withVotes: false);
      // set the vars
      this._user = user;
      this._nickname = user.nickName == null ? "" : user.nickName!;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void _onUpdateClicked() async {
    var requestData = UpdateUserRequest(this._nickname);
    try {
      await User.update(requestData);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(
          Size(300, 400),
        ),
        child: Column(
          children: [
            UserAvatar(
              uuid: _user!.userID,
              size: 200,
            ),
            SizedBox(height: 20),
            Text(
              _user!.name,
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            TextFormField(
              onChanged: (val) => _nickname = val,
              decoration: InputDecoration(
                labelText: "Nickname",
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _onUpdateClicked,
                child: Text("UPDATE"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
