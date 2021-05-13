import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/constants/colors.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/utilities/token.dart';
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

  late UserResponse _user;
  late GroupResponse _group;

  // SubRoutes for logged in users
  Map<String, WidgetBuilder> _loggedInRoutes = {};

  String _title = "JUI";

  String get title => _title;

  set title(String title) {
    setState(() {
      this._title = title;
    });
  }

  String _currentRoute = gamePage;

  _HomePageState() {
    _getData();
    this._loggedInRoutes = {
      "/": (BuildContext context) => Container(),
      gamePage: (BuildContext context) => GamePage(),
      profilePage: (BuildContext context) => ProfilePage(user: this._user, group: this._group),
    };
  }

  _getData() async {
    try {
      // retrieve the user id from the stored token
      var token = await Token.get();
      var user = await User.get(token.sub, withVotes: false);
      var groups = await this._getUsersGroups(user);

      // set the vars
      setState(() {
        this._group = groups[0];
        this._user = user;
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  // TODO remove
  Future<List<GroupResponse>> _getUsersGroups(UserResponse user) async {
    // get all the users groups
    List<GroupResponse> groups = [];
    for (var i = 0; i < user.groups!.length; i++) {
      var group = await this._getGroup(user.groups![i]);
      if (group != null) {
        groups.add(group);
      }
    }
    return groups;
  }

  // TODO remove
  Future<GroupResponse?> _getGroup(String groupId) async {
    try {
      var group = await Group.get(groupId);
      return group;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

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
      title = "JUI";
      this._currentRoute = gamePage;
    }
  }

  void _onProfileSelected() {
    if (this._currentRoute != profilePage) {
      _navigatorKey.currentState!.pushNamed(profilePage);
      title = "Settings";
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
                child: Text('No'),
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
              ),
              TextButton(
                child: Text('YES'),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });

    if (shouldLogout == true) {
      // Delete jwt and navigate back to login
      await DeviceStorage.removeValue(storageToken);
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
              subtitle: Text("Manage your profile, groups and games"),
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
                Navigator.pop(context);
                _onLogoutSelected();
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
