import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GamesPage extends StatefulWidget {
  GamesPage({Key? key}) : super(key: key);

  @override
  _GamesPageState createState() => _GamesPageState();
}

class _Game {
  final String name;
  final String description;

  _Game(this.name, this.description);
}

class _GamesPageState extends State<GamesPage> {
  List<_Game> games = [];

  _GamesPageState() {
    this.getData();
  }

  void getData() {
    this.games = [
      _Game("Waterfall",
          "Start drinking at the same time as the person to your left"),
      _Game("You", "Choose someone to drink"),
      _Game("Me", "You drink"),
      _Game("Floor", "Last person to touch the floor drinks"),
      _Game("Guys", "Guys drink"),
      _Game("Girls", "Girls drink"),
      _Game("Heaven", "Last person to raise their hand drinks"),
      _Game("Mate",
          "Choose someone to be your mate, they have to drink whenenever you drink"),
    ];
  }

  void _editGame(String name) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Edit $name!")));
  }

  void _confirmDeleteGame(_Game game) async {
    var shouldRemove = await showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text("Confirm"),
            content: Text(
                "Are you sure you want to delete the game \"${game.name}\"?"),
            actions: [
              TextButton(
                child: Text('Cancel'),
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

    if (shouldRemove == true) {
      _deleteGame(game);
    }
  }

  void _deleteGame(_Game game) {
    setState(() {
      this.games.removeWhere((element) => element == game);
    });

    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text("Deleted ${game.name}!")));
  }

  List<Widget> _games(BuildContext context) {
    List<Widget> gameWidgets = [];

    for (var i = 0; i < this.games.length; i++) {
      gameWidgets.add(Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                this.games[i].name,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () => _editGame(this.games[i].name)),
                      IconButton(
                          icon: Icon(Icons.delete_outline_rounded),
                          onPressed: () => _confirmDeleteGame(this.games[i])),
                    ],
                  )
                ],
              ),
            ],
          ),
          Text(
            this.games[i].description,
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
            ..._games(context),
          ],
        ),
      ),
    );
  }
}
