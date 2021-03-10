import 'package:flutter/material.dart';
import 'package:friendsbet/constants/colors.dart';
import 'package:friendsbet/models/request/login_request.dart';
import 'package:friendsbet/server/account.dart';
import 'package:friendsbet/utilities/popups.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Login"),
          actions: [
            Hero(
                tag: "app-logo",
                child: Image.asset(
                  "images/friends_logo.png",
                  width: 120,
                ))
          ],
        ),
        body: Center(
          child: Container(
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 300),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    onChanged: (val) => _email = val,
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    decoration: const InputDecoration(
                        labelText: "Enter your Email",
                        border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    onChanged: (val) => _password = val,
                    validator: validatePassword,
                    decoration: const InputDecoration(
                        labelText: "Enter your Password",
                        border: OutlineInputBorder()),
                  ),
                  FlatButton(
                    color: appAccentColor,
                    textColor: Colors.white,
                    padding: EdgeInsets.all(15),
                    minWidth: 300,
                    child: Text("Login", style: TextStyle(fontSize: 25)),
                    onPressed: onLoginClicked,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  onLoginClicked() async {
    if (_formKey.currentState.validate()) {
      // Form was filled out, attempt login
      var requestData = LoginRequest(this._email, this._password);
      try {
        var name = await Account.login(requestData);
        ScaffoldState scaffoldState = _scaffoldKey.currentState;
        scaffoldState.showSnackBar(
            SnackBar(content: Text("Welcome Back $name")));
      } catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err);
      }
    }
  }

  String validateEmail(String currentValue) {
    if (currentValue.isEmpty) {
      return "Please enter an email address";
    }
    if (!currentValue.contains("@")) {
      return "Please enter a valid email";
    }

    return null;
  }

  String validatePassword(String currentValue) {
    if (currentValue.isEmpty) {
      return "Please enter a password";
    }
    if (currentValue.length < 5) {
      return "Password must be at least 5 characters";
    }

    if (!currentValue.contains(RegExp("[1,2,3,4,5,6,7,8,9]"))) {
      return "Password needs at least 1 number";
    }

    return null;
  }
}
