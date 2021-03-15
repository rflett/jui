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
