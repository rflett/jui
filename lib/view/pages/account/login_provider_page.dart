import 'package:flutter/material.dart';
import 'package:jui/models/enums/social_providers.dart';
import 'package:jui/models/request/login_request.dart';
import 'package:jui/models/response/problem_response.dart';
import 'package:jui/server/account.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/components/social-login/social_login_button.dart';

class LoginProviderPage extends StatefulWidget {
  @override
  _LoginProviderPageState createState() => _LoginProviderPageState();
}

class _LoginProviderPageState extends State<LoginProviderPage> {
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Select a Login Provider"),
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
                  SocialLoginButton(SocialProviders.delegator),
                  SocialLoginButton(SocialProviders.google),
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
