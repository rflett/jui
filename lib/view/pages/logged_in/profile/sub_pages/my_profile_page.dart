import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/user/update_user.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class MyProfilePage extends StatefulWidget {
  final UserResponse user;

  MyProfilePage({Key? key, required this.user}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState(user);
}

class _MyProfilePageState extends State<MyProfilePage> {
  UserResponse? _user;
  TextEditingController _nicknameController =
      new TextEditingController(text: '');

  _MyProfilePageState(UserResponse user) {
    this._user = user;
    this._nicknameController.text = user.nickName == null ? "" : user.nickName!;
  }

  @override
  void dispose() {
    this._nicknameController.dispose();
    super.dispose();
  }

  void _onUpdateClicked() async {
    var requestData = UpdateUserRequest(this._nicknameController.text);
    try {
      await User.update(requestData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Profile updated.")));
      setState(() {
        this._nicknameController.text = requestData.nickName;
      });
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
              uuid: (this._user == null ? "" : this._user!.userID),
              size: 200,
            ),
            SizedBox(height: 20),
            Text(
              (this._user == null ? "" : this._user!.name),
              style: TextStyle(
                fontSize: 25,
              ),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _nicknameController,
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
