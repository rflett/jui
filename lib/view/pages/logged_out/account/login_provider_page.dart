import 'package:flutter/material.dart';
import 'package:jui/models/enums/social_providers.dart';

import 'components/social-login/social_login_button.dart';

class LoginProviderPage extends StatefulWidget {
  @override
  _LoginProviderPageState createState() => _LoginProviderPageState();
}

class _LoginProviderPageState extends State<LoginProviderPage> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: Text("Login with..."),
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
                  SocialLoginButton(SocialProviders.google),
                  SocialLoginButton(SocialProviders.spotify),
                  SocialLoginButton(SocialProviders.facebook),
                  SocialLoginButton(SocialProviders.instagram),
                ],
              ),
            ),
          ),
        ));
  }
}
