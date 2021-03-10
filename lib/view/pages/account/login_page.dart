import 'package:flutter/material.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/models/request/login_request.dart';
import 'package:jui/models/response/problem_response.dart';
import 'package:jui/server/account.dart';
import 'package:jui/utilities/popups.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

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
                  "images/logo.png",
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
                  TextButton(
                    style: TextButton.styleFrom(
                      backgroundColor: appAccentColor,
                      primary: Colors.white,
                      padding: EdgeInsets.all(15),
                      minimumSize: Size(300, 60),
                    ),
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
    if (_formKey.currentState?.validate() == true) {
      // Form was filled out, attempt login
      var requestData = LoginRequest(this._email, this._password);
      try {
        var name = await Account.login(requestData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Welcome Back $name")));
      } catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err as ProblemResponse);
      }
    }
  }

  String? validateEmail(String? currentValue) {
    if (currentValue?.isEmpty == true) {
      return "Please enter an email address";
    }
    if (currentValue?.contains("@") == false) {
      return "Please enter a valid email";
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
