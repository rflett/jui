import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/user/update_user.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/server/user.dart';
import 'package:jui/state/user_state.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:provider/provider.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  TextEditingController _nicknameController =
      new TextEditingController(text: '');

  _MyProfilePageState() {
    final currentUser = Provider.of<UserState>(context).user;
    this._nicknameController.text = currentUser?.nickName ?? "";
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
        child: Consumer<UserState>(
          builder: (context, userState, child) => Column(
            children: [
              UserAvatar(
                uuid: (userState.user?.userID ?? ""),
                size: 200,
              ),
              SizedBox(height: 20),
              Text(
                (userState.user?.name ?? ""),
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
      ),
    );
  }
}
