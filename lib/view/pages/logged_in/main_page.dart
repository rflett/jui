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
import 'package:jui/services/group_service.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/state/user_state.dart';
import 'package:jui/utilities/navigation.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/storage.dart';
import 'package:jui/utilities/token.dart';
import 'package:jui/view/pages/logged_in/components/user_avatar.dart';
import 'package:jui/view/pages/logged_in/home/home_page.dart';
import 'package:jui/view/pages/logged_in/profile/profile_page.dart';
import 'package:provider/provider.dart';

import 'components/group_dropdown.dart';

class MainPage extends StatefulWidget {
  final UserState userState = UserState();
  final GroupState groupState = GroupState();
  final String homePageRoute;

  MainPage({Key? key, required this.homePageRoute}) : super(key: key);

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final _navigatorKey = GlobalKey<NavigatorState>();
  String title = "";

  // SubRoutes for logged in users
  Map<String, WidgetBuilder> _loggedInRoutes = {};
  String _currentRoute = gamePage;

  _MainPageState() {
    _getData();
    this._loggedInRoutes = {
      "/": (BuildContext context) => Container(),
      gamePage: (BuildContext context) => HomePage(),
      profilePage: (BuildContext context) => ProfilePage(),
    };
  }

  _getData() async {
    try {
      // retrieve the user id from the stored token
      var token = await Token.get();
      var user = await User.get(token.sub, withVotes: false, withGroups: true);
      var primaryGroupId =
          await DeviceStorage.retrieveValue(storagePrimaryGroupId);
      var groups = user.groups ?? List.empty();

      final selectedGroup =
          groups.firstWhere((group) => group.groupID == primaryGroupId);

      // set the vars
      setState(() {
        title = selectedGroup.name;
      });
      widget.userState.updateUser(user);
      widget.groupState.updateGroupList(groups);
      widget.groupState.setSelectedGroup(selectedGroup);
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
    final selectedGroup = widget.groupState.groups
        .firstWhere((group) => group.groupID == groupId);

    widget.groupState.setSelectedGroup(selectedGroup);

    DeviceStorage.storeValue(storagePrimaryGroupId, groupId);
  }

  void _onGameSelected() {
    if (this._currentRoute != gamePage) {
      _navigatorKey.currentState!.pushNamed(gamePage);
      setState(() {
        title = widget.groupState.selectedGroup?.name ?? "";
        this._currentRoute = gamePage;
      });
    }
  }

  void _onProfileSelected() {
    if (this._currentRoute != profilePage) {
      _navigatorKey.currentState!.pushNamed(profilePage);
      setState(() {
        title = "Settings";
        this._currentRoute = profilePage;
      });
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
      Navigate(context).toLoginPage();
    }
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // Provide the state data down into children
        ChangeNotifierProvider(create: (context) => widget.userState),
        ChangeNotifierProvider(create: (context) => widget.groupState),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              DrawerHeader(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Consumer<UserState>(
                      builder: (context, userState, child) => Row(
                        children: [
                          UserAvatar(uuid: userState.user?.userID ?? ""),
                          Padding(
                            padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
                            child: Text(userState.user?.name ?? ""),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Consumer<GroupState>(
                        builder: (context, groupState, child) => GroupDropDown(
                          groups: groupState.groups,
                          onGroupSelected: (groupId) =>
                              _onGroupSelected(groupId),
                          initial: groupState.selectedGroup?.groupID ?? null,
                        ),
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
                subtitle:
                    Text("Check out the leaderboard and manage your votes"),
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
      ),
    );
  }
}
