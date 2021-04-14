import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/models/dto/request/account/signup.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/server/account.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/validation.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();

  bool _hidePassword = true;

  String _name = "";
  String _nickName = "";
  String _email = "";
  String _password = "";

  _onSignupClicked() async {
    if (_formKey.currentState?.validate() == true) {
      // Form was filled out, attempt login
      var requestData = SignUpRequest(
          this._name, this._nickName, this._email, this._password);
      try {
        var user = await Account.signUp(requestData);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Welcome, ${user.name}!")));
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
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Center(
        child: Column(children: [
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
                BoxConstraints(minWidth: 100, maxWidth: 300, maxHeight: 450),
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
                        validator: (val) => validateRequired(val),
                        decoration: InputDecoration(
                            labelText: "Name*", border: UnderlineInputBorder()),
                      ),
                      TextFormField(
                        onChanged: (val) => _email = val,
                        keyboardType: TextInputType.emailAddress,
                        validator: _validateEmail,
                        decoration: InputDecoration(
                            labelText: "Email*",
                            border: UnderlineInputBorder()),
                      ),
                      TextFormField(
                        onChanged: (val) => _password = val,
                        validator: _validatePassword,
                        obscureText: _hidePassword,
                        decoration: InputDecoration(
                            suffixIcon: IconButton(
                              icon: Icon(Icons.remove_red_eye),
                              onPressed: _onViewPasswordPressed,
                            ),
                            labelText: "Password*",
                            border: UnderlineInputBorder()),
                      ),
                      TextFormField(
                        onChanged: (val) => _email = val,
                        keyboardType: TextInputType.emailAddress,
                        validator: (val) => validateRequired(val),
                        decoration: InputDecoration(
                            labelText: "Nickname",
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
                          child:
                              Text("Sign Up", style: TextStyle(fontSize: 25)),
                          onPressed: _onSignupClicked,
                        ),
                      ),
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
}
