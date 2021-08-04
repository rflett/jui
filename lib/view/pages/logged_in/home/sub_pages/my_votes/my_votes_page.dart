import 'package:flutter/material.dart';
import 'package:jui/view/components/material_autocomplete.dart';

class MyVotesPage extends StatefulWidget {
  MyVotesPage({Key? key}) : super(key: key);

  @override
  _MyVotesPageState createState() => _MyVotesPageState();
}

class _MyVotesPageState extends State<MyVotesPage> {
  List<String> _songs = ["These", "Songs", "Don't", "Actually", "Search"];
  late List<Widget> _selectedList;

  _MyVotesPageState() {
    _selectedList = _generateSelectedList(_songs);
  }

  Iterable<String> _songList(TextEditingValue value) {
    // TODO link to search api
    return _songs;
  }

  static List<Widget> _generateSelectedList(List<String> songs) {
    // TODO link to selected api
    List<Widget> songWidgets = [];
    for (int i = 0; i < songs.length; i++) {
      songWidgets.add(
        ReorderableDragStartListener(
          key: Key("$i-song"),
          index: i,
          child: Column(
            children: [
              SizedBox(
                height: 60,
                child: Padding(
                  padding: EdgeInsets.all(10),
                  child: Row(
                    children: [
                      Text(
                        "${i + 1}.",
                        style: TextStyle(fontSize: 20),
                      ),
                      SizedBox(width: 10),
                      Column(
                        children: [
                          Text(songs[i],
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.bold)),
                          Text(
                            "Band Name",
                            style: TextStyle(fontSize: 12),
                          )
                        ],
                      ),
                      Spacer(),
                      Icon(Icons.view_headline_sharp, size: 30)
                    ],
                  ),
                ),
              ),
              Divider(),
            ],
          ),
        ),
      );
    }
    return songWidgets;
  }

  void _reorderList(int oldIndex, int newIndex) {
    var newList = [..._songs];
    var item = newList[oldIndex];
    newList.removeAt(oldIndex);
    newList.insert(newIndex, item);

    setState(() {
      _selectedList = _generateSelectedList(newList);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15),
      child: Column(
        children: [
          MaterialAutocomplete(
            optionsBuilder: _songList,
            labelText: "Search Songs",
          ),
          SizedBox(height: 20),
          Expanded(
            child: ReorderableListView(
              onReorder: _reorderList,
              children: _selectedList,
            ),
          ),
        ],
      ),
    );
  }
}
