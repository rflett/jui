import 'package:flutter/material.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/view/pages/account/login_page.dart';
import 'package:jui/view/pages/account/register_page.dart';
import 'package:jui/view/pages/account/login_provider_page.dart';
import 'package:jui/view/pages/home_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // Routes for users that aren't logged into the app right now
  final Map<String, WidgetBuilder> _loggedOutRoutes = {
    "/login-provider": (BuildContext context) => LoginProviderPage(),
    "/login": (BuildContext context) => LoginPage(),
    "/register": (BuildContext context) => RegisterPage(),
  };

  // Routes for users that are currently logged into the app
  final Map<String, WidgetBuilder> _loggedInRoutes = {};

  late Map<String, WidgetBuilder> _visibleRoutes;

  Future<bool> _initialise() async {
    String? jwt = await DeviceStorage.retrieveValue("jwt");
    this._visibleRoutes = _loggedOutRoutes;
    if (jwt != null && jwt.isNotEmpty) {
      // User is logged in
      print("logged in");
      return true;
    } else {
      // User not logged in
      print("logged out");
      return false;
    }
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
        future: _initialise(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return MaterialApp(
              title: 'JUI',
              theme: ThemeData(
                // This is the theme of your application.
                //
                // Try running your application with "flutter run". You'll see the
                // application has a blue toolbar. Then, without quitting the app, try
                // changing the primarySwatch below to Colors.green and then invoke
                // "hot reload" (press "r" in the console where you ran "flutter run",
                // or simply save your changes to "hot reload" in a Flutter IDE).
                // Notice that the counter didn't reset back to zero; the application
                // is not restarted.
                primarySwatch: Colors.blue,
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: HomePage(),
              routes: _visibleRoutes,
            );
          } else {
            // Still loading
            return Center(
                child: SizedBox(
              child: CircularProgressIndicator(),
              width: 60,
              height: 60,
            ));
          }
        });
  }
}
