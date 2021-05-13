import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/server/group.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/view/pages/logged_in/profile/sub_pages/components/create_update_game.dart';

class GamesPage extends StatefulWidget {
  final GroupResponse group;

  GamesPage({Key? key, required this.group}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState(group);
}

class _GamesPageState extends State<GamesPage> {
  // all groups that a user is a member of
  late GroupResponse _group;
  // all the games in the current group
  List<GameResponse> _games = [];
  // listeners
  late SettingsService _service;
  late StreamSubscription _serviceStream;

  _GamesPageState(GroupResponse group) {
    this._group = group;
    _getData();
    this._service = SettingsService.getInstance();
    this._serviceStream = _service.messages.listen(onMessageReceived);
  }

  @override
  void dispose() {
    this._serviceStream.cancel();
    super.dispose();
  }

  void _getData() async {
    var gamesResponse = await Group.getGames(this._group.groupID);
    setState(() {
      this._games = gamesResponse.games;
    });
  }

  void onMessageReceived(ProfileEvents event) {
    if (event == ProfileEvents.reloadGames) {
      this._getData();
    }
  }

  void _editGame(GameResponse game) async {
    var shouldRefresh = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CreateUpdateGamePopup(game: game, groupId: this._group.groupID);
      },
    );
    if (shouldRefresh == true) {
      this._getData();
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
            Divider(),
            ..._gameList(context),
            Visibility(
                visible: this._games.length == 0,
                child: Text("Create some games with the button below!"))
          ],
        ),
      ),
    );
  }
}
