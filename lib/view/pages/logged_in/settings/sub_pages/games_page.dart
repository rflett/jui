import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/server/group.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/view/pages/logged_in/settings/sub_pages/components/create_update_game.dart';
import 'package:provider/provider.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  // all the games in the current group
  List<GameResponse> _games = List.empty();

  _GamesPageState() {
    _getData();
  }

  void _getData() async {
    final groupState = Provider.of<GroupState>(context, listen: false);

    var gamesResponse = await Group.getGames(groupState.selectedGroup!.groupID);
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
    final groupState = Provider.of<GroupState>(context, listen: false);
    var shouldRefresh = await showDialog<bool>(
      context: context,
      builder: (context) {
        return CreateUpdateGamePopup(
            game: game, groupId: groupState.selectedGroup!.groupID);
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
