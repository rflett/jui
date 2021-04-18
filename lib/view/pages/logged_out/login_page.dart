import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/models/dto/request/account/signin.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/enums/social_providers.dart';
import 'package:jui/server/account.dart';
import 'package:jui/utilities/popups.dart';

import 'components/social-login/social_login_button.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _socialLoginVisible = false;
  bool _hidePassword = true;
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  // One time use because it hides the button to show it
  void _showSocialLogin() {
    setState(() {
      _socialLoginVisible = true;
    });
  }

  _onLoginClicked() async {
    if (_formKey.currentState?.validate() == true) {
      // Form was filled out, attempt login
      var requestData = SignInRequest(this._email, this._password);
      try {
        var user = await Account.signIn(requestData);
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Welcome back, ${user.name}!")));
        Navigator.pushNamedAndRemoveUntil(context, gameRoute, (route) => false);
      } catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err as ProblemResponse);
      }
    }
  }

  _onViewPasswordPressed() {
    setState(() => this._hidePassword = !this._hidePassword);
  }

  String? _validateEmail(String? currentValue) {
    if (currentValue?.isEmpty == true) {
      return "Please enter an email address";
    }
    if (currentValue?.contains("@") == false) {
      return "Please enter a valid email";
    }

    return null;
  }

  String? _validatePassword(String? currentValue) {
    if (currentValue != null) {
      if (currentValue.isEmpty) {
        return "Please enter a password";
      }
      if (currentValue.length < 5) {
        return "Password must be at least 5 characters";
      }

      if (!currentValue.contains(RegExp("\\d+"))) {
        return "Password needs at least 1 number";
      }
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Hero(
              tag: "login-logo",
              child: Image.asset(
                "assets/images/logo.png",
                width: 300,
              ),
            ),
          ),
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 500),
            child: Container(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    Wrap(runSpacing: 10, children: [
                      TextFormField(
                        onChanged: (val) => _email = val,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle_rounded),
                            labelText: "Email",
                            border: OutlineInputBorder()),
                      ),
                      TextFormField(
                        onChanged: (val) => _password = val,
                        validator: _validatePassword,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: _onViewPasswordPressed,
                            ),
                            labelText: "Password",
                            border: OutlineInputBorder()),
                      ),
                      Align(
                        alignment: AlignmentDirectional.centerEnd,
                        child: TextButton(
                          child: Text("LOGIN"),
                          onPressed: _onLoginClicked,
                        ),
                      ),
                    ]),
                    Column(children: [
                      IgnorePointer(
                        ignoring: _socialLoginVisible,
                        child: AnimatedOpacity(
                          duration: Duration(milliseconds: 200),
                          curve: Curves.easeInOutCubic,
                          opacity: _socialLoginVisible ? 0 : 1,
                          child: TextButton(
                            onPressed: _showSocialLogin,
                            child: Text("SOCIAL LOGIN"),
                            style: ButtonStyle(),
                          ),
                        ),
                      ),
                      AnimatedContainer(
                        duration: Duration(milliseconds: 500),
                        curve: Curves.easeInOutCubic,
                        height: _socialLoginVisible ? 200 : 0,
                        child: ClipRect(
                          child: Wrap(
                            runSpacing: 10,
                            children: [
                              SocialLoginButton(SocialProviders.google),
                              SocialLoginButton(SocialProviders.spotify),
                              SocialLoginButton(SocialProviders.facebook),
                              SocialLoginButton(SocialProviders.instagram),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      TextButton(
                        onPressed: () =>
                            Navigator.pushNamed(context, registerRoute),
                        child: Text("SIGNUP WITH EMAIL"),
                      ),
                    ]),
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
