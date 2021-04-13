import 'package:flutter/material.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/constants/routes.dart';
import 'package:jui/models/dto/request/account/signin.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/server/account.dart';
import 'package:jui/utilities/popups.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hidePassword = true;
  String _email = "";
  String _password = "";

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
            children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 20),
            child: Hero(
              tag: "app-logo",
              child: Image.asset(
                "images/logo.png",
                width: 300,
              ),
            ),
          ),
          ConstrainedBox(
            constraints:
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 400),
            child: Card(
              elevation: 3,
              child: Container(
                padding: EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextFormField(
                        onChanged: (val) => _email = val,
                        keyboardType: TextInputType.emailAddress,
                        validator: validateEmail,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.account_circle_rounded),
                            labelText: "Email",
                            border: UnderlineInputBorder()),
                      ),
                      TextFormField(
                        onChanged: (val) => _password = val,
                        validator: validatePassword,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: onViewPasswordPressed,
                            ),
                            labelText: "Password",
                            border: UnderlineInputBorder()),
                      ),
                      Hero(
                        tag: "login-button",
                        child: TextButton(
                          style: TextButton.styleFrom(
                            backgroundColor: appPrimaryColor,
                            primary: Colors.white,
                            padding: EdgeInsets.all(15),
                            minimumSize: Size(300, 60),
                          ),
                          child: Text("Login", style: TextStyle(fontSize: 25)),
                          onPressed: onLoginClicked,
                        ),
                      ),
                      Column(children: [
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, loginProviderRoute),
                          child: Text("Social Login"),
                        ),
                        TextButton(
                          onPressed: () =>
                              Navigator.pushNamed(context, registerRoute),
                          child: Text("Sign up"),
                        ),
                      ]),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  onLoginClicked() async {
    if (_formKey.currentState?.validate() == true) {
      // Form was filled out, attempt login
      var requestData = SignInRequest(this._email, this._password);
      try {
        var name = await Account.signIn(requestData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Welcome, $name!")));
      } catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err as ProblemResponse);
      }
    }
  }

  onViewPasswordPressed() {
    setState(() => this._hidePassword = !this._hidePassword);
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

      if (!currentValue.contains(RegExp("\\d+"))) {
        return "Password needs at least 1 number";
      }
    }
    return null;
  }
}
