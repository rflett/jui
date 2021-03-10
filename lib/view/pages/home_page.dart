import 'package:flutter/material.dart';
import 'package:jui/constants/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Hero(tag: "app-logo", child: Image.asset("images/logo.png")),
          Container(
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 300),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: appPrimaryColor,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                    minimumSize: Size(300, 60),
                  ),
                  child: Text("Login", style: TextStyle(fontSize: 25)),
                  onPressed: () =>
                      Navigator.pushNamed(context, "/login-provider"),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    backgroundColor: appSecondaryColor,
                    primary: Colors.white,
                    padding: EdgeInsets.all(15),
                    minimumSize: Size(300, 60),
                  ),
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
