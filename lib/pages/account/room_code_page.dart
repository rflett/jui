import 'package:flutter/material.dart';
import 'package:friendsbet/constants/colors.dart';

class RoomCodePage extends StatefulWidget {
  @override
  _RoomCodePageState createState() => _RoomCodePageState();
}

class _RoomCodePageState extends State<RoomCodePage> {
  String _roomCode = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("View Room")
        ),
        body: Center(
      child: Container(
        constraints:
            BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 450),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Hero(tag: "app-logo", child: Image.asset("images/friends_logo.png")),
              TextFormField(
                onChanged: (val) => _roomCode = val,
                validator: validateCode,
                decoration: const InputDecoration(
                    labelText: "Enter the room code",
                    border: OutlineInputBorder()),
              ),
              FlatButton(
                color: appAccentColor,
                textColor: Colors.white,
                padding: EdgeInsets.all(15),
                minWidth: 300,
                child: Text("View Room", style: TextStyle(fontSize: 25)),
                onPressed: onViewClicked,
              )
            ],
          ),
        ),
      ),
    ));
  }

  onViewClicked() {
    if (_formKey.currentState.validate()) {
      // Form was filled out, attempt login
    }
  }

  String validateCode(String currentValue) {
    if (currentValue.isEmpty) {
      return "Please enter a code";
    }
    if (currentValue.length != 6) {
      return "Room codes are 6 characters long";
    }

    return null;
  }
}
