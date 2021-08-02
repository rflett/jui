import 'dart:io';

import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/view/pages/logged_in/home_page.dart';
import 'package:jui/view/pages/logged_in/setup/invite_group_page.dart';
import 'package:jui/view/pages/logged_in/setup/setup_group_page.dart';
import 'package:jui/view/pages/logged_out/login_page.dart';
import 'package:jui/view/pages/logged_out/register_page.dart';
import 'package:jui/view/pages/shared/loading_page.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // Routes for users that aren't logged into the app right now
  final Map<String, WidgetBuilder> _topLevelRoutes = {
    loginRoute: (BuildContext context) => LoginPage(),
    registerRoute: (BuildContext context) => RegisterPage(),
    firstTimeSetupGroupRoute: (BuildContext context) => SetupGroupPage(),
    firstTimeSetupInviteRoute: (BuildContext context) => InviteGroupPage(),
  };

  late Widget _defaultWidget;

  Future<bool> _initialise() async {
    String? jwt = await DeviceStorage.retrieveValue("jwt");
    if (jwt != null && jwt.isNotEmpty) {
      // User is logged in
      _defaultWidget = HomePage(homePageRoute: "/game");
      return true;
    } else {
      // User not logged in
      _defaultWidget = LoginPage();
      return false;
    }
  }

  // Called whenever the app navigates to a route (Allows handling nested routing)
  MaterialPageRoute _handleRoute(RouteSettings settings) {
    late WidgetBuilder page;
    if (settings.name == null) {
      throw Exception('App route was empty');
    }

    if (settings.name!.startsWith(dashboardRoute) == true) {
      // Get the initial subroute
      var subRoute = settings.name!.substring(dashboardRoute.length);
      page = (BuildContext context) => HomePage(homePageRoute: subRoute);
    } else if (_topLevelRoutes.containsKey(settings.name)) {
      // Is a top level route instead
      page = _topLevelRoutes[settings.name]!;
    } else {
      throw Exception('Unsupported application route ${settings.name}');
    }

    return MaterialPageRoute(builder: page, settings: settings);
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
                primarySwatch: Colors.indigo,
                // This makes the visual density adapt to the platform that you run
                // the app on. For desktop platforms, the controls will be smaller and
                // closer together (more dense) than on mobile platforms.
                visualDensity: VisualDensity.adaptivePlatformDensity,
              ),
              home: _defaultWidget,
              routes: _topLevelRoutes,
              onGenerateRoute: (settings) => _handleRoute(settings),
            );
          } else {
            // Still loading
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
