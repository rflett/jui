import 'package:flutter/material.dart';
import 'package:friendsbet/constants/colors.dart';
import 'package:friendsbet/models/request/registration_request.dart';
import 'package:friendsbet/server/account.dart';
import 'package:friendsbet/utilities/popups.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _username = "";
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Register"),
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
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 350),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextFormField(
                    onChanged: (val) => _username = val,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: "Enter your Name",
                        border: OutlineInputBorder()),
                  ),
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
                    obscureText: true,
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
                    child: Text("Register", style: TextStyle(fontSize: 25)),
                    onPressed: onRegisterClicked,
                  )
                ],
              ),
            ),
          ),
        ));
  }

  onRegisterClicked() async {
    if (_formKey.currentState.validate()) {
      // Form was filled out, attempt login
      var requestData =
          RegistrationRequest(this._username, this._email, this._password);
      try {
        var name = await Account.register(requestData);
        ScaffoldState scaffoldState = _scaffoldKey.currentState;
        scaffoldState.showSnackBar(
            SnackBar(content: Text("Thanks for registering $name")));
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
