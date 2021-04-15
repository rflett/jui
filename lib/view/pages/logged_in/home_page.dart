import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/view/pages/logged_in/game/game_page.dart';
import 'package:jui/view/pages/logged_in/profile/profile_page.dart';

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
    gamePage: (BuildContext context) => GamePage(),
    profilePage: (BuildContext context) => ProfilePage(),
  };

  String _title = "Games";

  String get title => _title;

  set title(String title) {
    setState(() {
      this._title = title;
    });
  }

  String _currentRoute = gamePage;

  // Called whenever the app navigates to a route.
  MaterialPageRoute _handleRoute(RouteSettings settings) {
    if (!_loggedInRoutes.containsKey(settings.name)) {
      throw Exception('Unsupported nested route ${settings.name}');
    }

    WidgetBuilder page = _loggedInRoutes[settings.name]!;

    return MaterialPageRoute(builder: page, settings: settings);
  }

  void _onGameSelected() {
    if (this._currentRoute != gamePage) {
      _navigatorKey.currentState!.pushNamed(gamePage);
      title = "Games";
      this._currentRoute = gamePage;
    }
  }

  void _onProfileSelected() {
    if (this._currentRoute != profilePage) {
      _navigatorKey.currentState!.pushNamed(profilePage);
      title = "My Profile";
      this._currentRoute = profilePage;
    }
  }

  void _onLogoutSelected() async {
    var shouldLogout = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Log Out"),
            content: Text("Are you sure you want to log out?"),
            actions: [
              TextButton(
                child: Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
              TextButton(
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
            ],
          );
        });

    if (shouldLogout == true) {
      // Delete jwt and navigate back to login
      await DeviceStorage.removeValue(storageJwtKey);
      Navigator.pushNamedAndRemoveUntil(context, loginRoute, (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Image.asset(
                "assets/images/logo.png",
              ),
              padding: EdgeInsets.zero,
              decoration: BoxDecoration(
                color: appPrimaryColor,
              ),
            ),
            ListTile(
              leading: Icon(Icons.music_note),
              title: Text('Play'),
              subtitle: Text("Check out the leaderboard and manage your votes"),
              onTap: () {
                _onGameSelected();
                Navigator.pop(context);
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Profile'),
              subtitle: Text("Manage your Groups and Custom Games"),
              onTap: () {
                _onProfileSelected();
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(
                Icons.logout,
                color: Colors.red,
              ),
              title: Text(
                "Log Out",
                style: TextStyle(color: Colors.red),
              ),
              subtitle: Text(
                "Log out of your account",
                style: TextStyle(color: Colors.red),
              ),
              onTap: () {
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
