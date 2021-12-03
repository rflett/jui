import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/state/game_state.dart';
import 'package:jui/state/group_state.dart';
import 'package:jui/view/pages/logged_in/settings/components/create_update_game.dart';
import 'package:jui/view/pages/logged_in/settings/games/components/game_list.dart';
import 'package:provider/provider.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _GamesPageState extends State<GamesPage> {
  @override
  void initState() {
    super.initState();
    _getData();
  }

  void _getData() async {
    final groupState = Provider.of<GroupState>(context, listen: false);

    var groupId = groupState.selectedGroup?.groupID;
    if (groupId != null) {
      Provider.of<GameState>(context, listen: false).loadGames(groupId);
    }
  }

  void _editGame(GameResponse game) async {
    final groupState = Provider.of<GroupState>(context, listen: false);
    var groupId = groupState.selectedGroup?.groupID;

    if (groupId != null) {
      await showDialog<bool>(
        context: context,
        builder: (context) {
          return CreateUpdateGamePopup(game: game, groupId: groupId);
        },
      );
      Provider.of<GameState>(context, listen: false).loadGames(groupId);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Center(
        child: Flex(
          direction: Axis.vertical,
          children: [
            Text(
              "Games",
              textAlign: TextAlign.left,
              style: Theme.of(context).textTheme.headline5,
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(0, 5, 0, 5),
              child: Text(
                "If someone in your group voted for a song that gets played, then everyone gets prompted to participate in one of these games\n"
                "We pick the game to play at random.",
                textAlign: TextAlign.left,
                style: Theme.of(context).textTheme.bodyText2,
              ),
            ),
            Divider(),
            Expanded(child: Consumer<GameState>(
                builder: (BuildContext context, state, Widget? child) {
              if (state.value.length == 0) {
                return Text("Create some games with the button below!");
              } else {
                return GameList(games: state.value, editGame: _editGame);
              }
            })),
          ],
        ),
      ),
    );
  }
}
