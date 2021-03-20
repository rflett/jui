import 'package:flutter/material.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/view/pages/account/login_page.dart';
import 'package:jui/view/pages/account/register_page.dart';
import 'package:jui/view/pages/account/login_provider_page.dart';
import 'package:jui/view/pages/home_page.dart';
import 'package:jui/view/pages/leaderboard/leaderboard.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
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
      return true;
    } else {
      // User not logged in
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
                primarySwatch: Colors.blue,
                backgroundColor: Colors.grey.shade50,
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: Leaderboard(),
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
