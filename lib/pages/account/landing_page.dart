import 'package:flutter/material.dart';
import 'package:friendsbet/constants/colors.dart';

class LandingPage extends StatefulWidget {
  @override
  _LandingPageState createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(tag: "app-logo", child: Image.asset("images/friends_logo.png")),
          Container(
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                FlatButton(
                  color: appPrimaryColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  minWidth: 300,
                  child: Text("View Room", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.pushNamed(context, "/enter-code"),
                ),
                FlatButton(
                  color: appAccentColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  minWidth: 300,
                  child: Text("Login", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.pushNamed(context, "/login"),
                ),
                FlatButton(
                  color: appSecondaryColor,
                  textColor: Colors.white,
                  padding: EdgeInsets.all(15),
                  minWidth: 300,
                  child: Text("Register", style: TextStyle(fontSize: 25)),
                  onPressed: () => Navigator.pushNamed(context, "/register"),
                )
              ],
            ),
          ),
        ],
      ),
    ));
  }
}
