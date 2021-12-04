import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/state/game_state.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/view/pages/logged_in/settings/components/create_update_game.dart';
import 'package:jui/view/pages/logged_in/settings/components/create_update_group.dart';
import 'package:jui/view/pages/logged_in/settings/games/games_page.dart';
import 'package:jui/view/pages/logged_in/settings/groups/groups_page.dart';
import 'package:jui/view/pages/logged_in/settings/profile/my_profile_page.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatefulWidget {
  SettingsPage({Key? key}) : super(key: key);

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  final GameState gameState = new GameState(List.empty());
  ProfilePages _currentPage = ProfilePages.myProfile;
  PageController _controller = PageController(keepPage: false);
  Map<ProfilePages, Widget> _profilePages = {};

  _SettingsPageState() {
    this._profilePages = Map.fromEntries([
      MapEntry(
        ProfilePages.myProfile,
        MyProfilePage(),
      ),
      MapEntry(
        ProfilePages.myGroups,
        GroupsPage(),
      ),
      MapEntry(
        ProfilePages.myGames,
        GamesPage(),
      ),
    ]);
  }

  void _onNavIconTapped(int index) {
    setState(() {
      this._currentPage = _getCurrentFromIndex(index);
      _controller.animateToPage(index,
          duration: Duration(milliseconds: 400), curve: Curves.easeInOut);
    });
  }

  void _onPageSwiped(int index) {
    setState(() {
      this._currentPage = _getCurrentFromIndex(index);
    });
  }

  ProfilePages _getCurrentFromIndex(int index) {
    ProfilePages currentPage;
    switch (index) {
      case 0:
        currentPage = ProfilePages.myProfile;
        break;
      case 1:
        currentPage = ProfilePages.myGroups;
        break;
      case 2:
        currentPage = ProfilePages.myGames;
        break;
      default:
        currentPage = ProfilePages.myProfile;
        break;
    }
    return currentPage;
  }

  void _createGroupPressed() {
    showDialog(
      context: context,
      builder: (context) {
        return CreateUpdateGroupPopup();
      },
    );
  }

  void _createGamePressed(String? groupId) async {
    if (groupId != null) {
      await showDialog(
        context: context,
        builder: (context) {
          return CreateUpdateGamePopup(groupId: groupId);
        },
      );
      gameState.loadGames(groupId);
    }
  }

  Widget? _currentFab() {
    switch (this._currentPage) {
      case ProfilePages.myProfile:
        return null;
      case ProfilePages.myGroups:
        return groupsPageFab();
      case ProfilePages.myGames:
        return gamesPageFab();
    }
  }

  Widget groupsPageFab() {
    return FloatingActionButton(
      onPressed: () => _createGroupPressed(),
      child: const FaIcon(FontAwesomeIcons.plus),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  Widget gamesPageFab() {
    final selectedGroupId =
        Provider.of<GroupState>(context).selectedGroup?.groupID;
    return FloatingActionButton(
      onPressed: () => _createGamePressed(selectedGroupId),
      child: const FaIcon(FontAwesomeIcons.plus),
      backgroundColor: Theme.of(context).colorScheme.primary,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider(
      create: (context) => gameState,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Theme.of(context).primaryColor,
          items: [
            BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.user), label: "My Profile"),
            BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.users), label: "My Group"),
            BottomNavigationBarItem(
                icon: const FaIcon(FontAwesomeIcons.gamepad), label: "Games"),
          ],
          currentIndex: this._currentPage.index,
          selectedItemColor: Colors.white,
          unselectedItemColor: Colors.grey.shade300.withAlpha(150),
          onTap: _onNavIconTapped,
        ),
        body: PageView(
            controller: _controller,
            onPageChanged: _onPageSwiped,
            children: [
              MyProfilePage(),
              GroupsPage(),
              GamesPage(),
            ]),
        floatingActionButton: _currentFab(),
      ),
    );
  }
}
