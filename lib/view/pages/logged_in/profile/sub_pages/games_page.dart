import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/token.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_game.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  // drop down menu item for selecting the current group
  List<DropdownMenuItem<String>> _selectedGroupOptions = [];
  // id of the currently selected group from the drop down
  String? _selectedGroupId;
  // all groups that a user is a member of
  List<GroupResponse> _groups = [];
  // all the games in the current group
  List<GameResponse> _games = [];
  // the current logged in user
  UserResponse? user;

  _GamesPageState() {
    this.getData();
  }

  void getData() async {
    try {
      // retrieve the user id from the stored token
      var tkn = await Token.get();
      var user = await User.get(tkn.sub, withVotes: false);
      this.user = user;

      // get all the users groups
      // TODO this should be 1 API call
      List<GroupResponse> groups = [];
      for (var i = 0; i < this.user!.groups!.length; i++) {
        var group = await this._getGroup(this.user!.groups![i]);
        if (group != null) {
          groups.add(group);
        }
      }
      this._groups = groups;

      // generate the drop down items and select the first group in the list
      _generateDropDownItems();
      this._selectGroup(this._groups[0].groupID);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

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

  /// generates the group drop down menu items from the users groups
  void _generateDropDownItems() {
    this._selectedGroupOptions = this
        ._groups
        .map((element) => DropdownMenuItem<String>(
        value: element.groupID, child: Text(element.name)))
        .toList();
  }

  /// called when a group is selected from the drop down, updates the page data
  void _selectGroup(String? groupId) async {
    try {
      var gamesResponse = await Group.getGames(groupId!);
      setState(() {
        this._selectedGroupId = groupId;
        this._games = gamesResponse.games;
      });
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void _editGame(GameResponse game) async {
    var shouldRefresh = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CreateUpdateGamePopup(game: game, groupId: this._selectedGroupId!);
      },
    );
    if (shouldRefresh == true) {
      setState(() {
        _selectGroup(this._selectedGroupId);
      });
    }
  }

  List<Widget> _gameList(BuildContext context) {
    List<Widget> gameWidgets = [];

    for (var i = 0; i < this._games.length; i++) {
      gameWidgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this._games[i].name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: Icon(Icons.edit),
                onPressed: () => _editGame(this._games[i]),
              ),
            ],
          ),
          Text(
            this._games[i].description,
            textAlign: TextAlign.left,
            style: TextStyle(fontSize: 16),
          ),
          SizedBox(height: 10),
          Divider()
        ],
      ));
    }

    return gameWidgets;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints.loose(
          Size(300, 600),
        ),
        child: ListView(
          children: [
            Text("Games",
                textAlign: TextAlign.left,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "When a song gets played on the day, "
                "if someone in your group voted for it then everyone "
                "gets prompted to participate in one of these games\n"
                "We pick the game to play at random.",
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 16),
              ),
            ),
            DropdownButton(
              value: _selectedGroupId,
              onChanged: (String? newValue) => _selectGroup(newValue),
              items: _selectedGroupOptions,
            ),
            Divider(),
            ..._gameList(context),
          ],
        ),
      ),
    );
  }
}
