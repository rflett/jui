import 'package:flutter/material.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';

class MyProfilePage extends StatefulWidget {
  MyProfilePage({Key? key}) : super(key: key);

  @override
  _MyProfilePageState createState() => _MyProfilePageState();
}

class _MyProfilePageState extends State<MyProfilePage> {
  String _nickname = "";

  void _onUpdateClicked() {}

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
              uuid: "ffdsf",
              size: 200,
            ),
            SizedBox(height: 20),
            Text(
              "James Turner",
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
