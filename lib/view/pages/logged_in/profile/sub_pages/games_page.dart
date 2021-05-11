import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/server/group.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_game.dart';

import 'components/group_dropdown.dart';

class GamesPage extends StatefulWidget {
  final List<GroupResponse> groups;
  final void Function(String) onGroupSelected;

  GamesPage({Key? key, required this.groups, required this.onGroupSelected}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState(groups, onGroupSelected);
}

class _GamesPageState extends State<GamesPage> {
  // id of the currently selected group from the drop down
  String? _selectedGroupId;
  late void Function(String) _selectGroupCallback;
  // all groups that a user is a member of
  List<GroupResponse> _groups = [];
  // all the games in the current group
  List<GameResponse> _games = [];

  _GamesPageState(List<GroupResponse> groups, Function(String) selectGroupCallback) {
    this._selectGroupCallback = selectGroupCallback;
    this._groups = groups;
  }

  /// called when a group is selected from the drop down, updates the page data
  void _selectGroup(String? groupId) async {
    try {
      var gamesResponse = await Group.getGames(groupId!);
      setState(() {
        this._selectedGroupId = groupId;
        this._games = gamesResponse.games;
        this._selectGroupCallback(groupId);
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
            GroupDropDown(
              groups: this._groups,
              onGroupSelected: (groupId) => this._selectGroup(groupId),
            ),
            Divider(),
            ..._gameList(context),
          ],
        ),
      ),
    );
  }
}
