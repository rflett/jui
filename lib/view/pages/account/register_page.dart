import 'package:flutter/material.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/models/dto/request/account/signup.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/server/account.dart';
import 'package:jui/utilities/popups.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _username = "";
  String? _nickname = "";
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
                  "images/logo.png",
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
                    onChanged: (val) => _nickname = val,
                    keyboardType: TextInputType.text,
                    decoration: const InputDecoration(
                        labelText: "Enter a Nickname (Optional)",
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
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: appAccentColor,
                      primary: Colors.white,
                      padding: EdgeInsets.all(15),
                      minimumSize: Size(300, 60),
                    ),
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
    if (_formKey.currentState?.validate() == true) {
      // Form was filled out, attempt login
      var normalisedNickname =
          this._nickname?.isNotEmpty ?? false ? this._nickname : this._username;

      var requestData = SignUpRequest(
          this._username, normalisedNickname!, this._email, this._password);
      try {
        var name = await Account.register(requestData);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Thanks for registering $name")));
      } on ProblemResponse catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err);
      }
    }
  }

  String? validateEmail(String? currentValue) {
    if (currentValue != null) {
      if (currentValue.isEmpty) {
        return "Please enter an email address";
      }
      if (!currentValue.contains("@")) {
        return "Please enter a valid email";
      }
    }
    return null;
  }

  String? validatePassword(String? currentValue) {
    if (currentValue != null) {
      if (currentValue.isEmpty) {
        return "Please enter a password";
      }
      if (currentValue.length < 5) {
        return "Password must be at least 5 characters";
      }

      if (!currentValue.contains(RegExp("[1,2,3,4,5,6,7,8,9]"))) {
        return "Password needs at least 1 number";
      }
    }

    return null;
  }
}
