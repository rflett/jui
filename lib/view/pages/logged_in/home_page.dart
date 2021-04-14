import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/view/pages/logged_in/game/leaderboard/leaderboard.dart';
import 'package:jui/view/pages/logged_in/profile/profile_page.dart';
import 'package:jui/view/pages/logged_out/account/login_provider_page.dart';

class HomePage extends StatefulWidget {
  final String homePageRoute;

  HomePage({Key? key, required this.homePageRoute}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  // SubRoutes for logged in users
  final Map<String, WidgetBuilder> _loggedInRoutes = {
    "/": (BuildContext context) => Container(),
    gamePage: (BuildContext context) => Leaderboard(),
    profilePage: (BuildContext context) => ProfilePage(),
  };

  // Called whenever the app navigates to a route.
  MaterialPageRoute _handleRoute(RouteSettings settings) {
    if (!_loggedInRoutes.containsKey(settings.name)) {
      throw Exception('Unsupported nested route ${settings.name}');
    }

    WidgetBuilder page = _loggedInRoutes[settings.name]!;

    return MaterialPageRoute(builder: page, settings: settings);
  }



  void _onGameSelected() {
    _navigatorKey.currentState!.pushNamed(gamePage);
  }

  void _onProfileSelected() {
    _navigatorKey.currentState!.pushNamed(profilePage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('JUI Home'),
      ),
      drawer: Drawer(
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Drawer Header'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Games'),
              onTap: () {
                // Update the state of the app.
                // ...
                _onGameSelected();
                Navigator.pop(context);
              },
            ),
            ListTile(
              title: Text('Profile'),
              onTap: () {
                // Update the state of the app.
                // ...
                _onProfileSelected();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Navigator(
        key: _navigatorKey,
        initialRoute: widget.homePageRoute,
        onGenerateRoute: (settings) => _handleRoute(settings),
      ),
    );
  }
}
