import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';

class GameList extends StatelessWidget {
  final List<GameResponse> games;
  final void Function(GameResponse) editGame;

  const GameList({Key? key, required this.games, required this.editGame})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemCount: games.length,
      itemBuilder: (BuildContext context, int i) {
        return Card(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Flex(
              direction: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        games[i].name,
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        games[i].description,
                        textAlign: TextAlign.left,
                        style: TextStyle(fontSize: 16),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  width: 70,
                  child: IconButton(
                    icon: Icon(Icons.edit),
                    onPressed: () => editGame(games[i]),
                  ),
                )
              ],
            ),
          ),
        );
      },
      separatorBuilder: (context, index) => SizedBox(height: 15),
    );
  }
}
