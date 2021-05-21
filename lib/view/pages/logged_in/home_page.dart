import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jui/constants/app_routes.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/server/group.dart';
import 'package:jui/server/user.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/utilities/token.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:jui/view/pages/logged_in/game/game_page.dart';
import 'package:jui/view/pages/logged_in/profile/profile_page.dart';

import 'components/group_dropdown.dart';

class HomePage extends StatefulWidget {
  final String homePageRoute;

  HomePage({Key? key, required this.homePageRoute}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  // state
  UserResponse? _user;
  GroupResponse? _selectedGroup;
  List<GroupResponse> _groups = [];

  // SubRoutes for logged in users
  Map<String, WidgetBuilder> _loggedInRoutes = {};
  String _currentRoute = gamePage;

  // listeners
  late SettingsService _service;
  late StreamSubscription _serviceStream;

  // page title
  String _title = "JUI";
  String get title => _title;

  set title(String title) {
    setState(() {
      this._title = title;
    });
  }

  _HomePageState() {
    _getData();
    this._loggedInRoutes = {
      "/": (BuildContext context) => Container(),
      gamePage: (BuildContext context) => GamePage(),
      profilePage: (BuildContext context) =>
          ProfilePage(user: this._user!, group: this._selectedGroup!),
    };
    this._service = SettingsService.getInstance();
    this._serviceStream = _service.messages.listen(onMessageReceived);
  }

  @override
  void dispose() {
    this._serviceStream.cancel();
    super.dispose();
  }

  _getData() async {
    try {
      // retrieve the user id from the stored token
      var token = await Token.get();
      var user = await User.get(token.sub, withVotes: false, withGroups: true);
      var primaryGroupId =
          await DeviceStorage.retrieveValue(storagePrimaryGroupId);

      // set the vars
      setState(() {
        this._groups = user.groups == null ? [] : user.groups!;
        this._user = user;
        this._selectedGroup = this
            ._groups
            .firstWhere((group) => group.groupID == primaryGroupId!);
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void onMessageReceived(ProfileEvents event) {
    if (event == ProfileEvents.reloadGroups) {
      // TODO reload the groups and refresh the ProfilePage
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

  void _onGroupSelected(String groupId) {
    setState(() {
      this._selectedGroup =
          this._groups.firstWhere((group) => group.groupID == groupId);
    });
    DeviceStorage.storeValue(storagePrimaryGroupId, groupId);
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
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      UserAvatar(uuid: this._user == null ? "" : this._user!.userID),
                      Padding(
                        padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                        child: Text(this._user == null ? "" : this._user!.name),
                      ),
                    ],
                  ),
                  Expanded(
                    child: GroupDropDown(
                      groups: this._groups,
                      onGroupSelected: (groupId) => _onGroupSelected(groupId),
                      initial: this._selectedGroup == null ? null : this._selectedGroup!.groupID,
                    ),
                  ),
                ],
              ),
              decoration: BoxDecoration(
                color: Colors.white24,
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
            SizedBox(height: 10),
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
