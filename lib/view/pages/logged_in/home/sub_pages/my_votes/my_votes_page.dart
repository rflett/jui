import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jui/server/search.dart';
import 'package:jui/view/components/material_autocomplete.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/song_search_item.dart';

class MyVotesPage extends StatefulWidget {
  MyVotesPage({Key? key}) : super(key: key);

  @override
  _MyVotesPageState createState() => _MyVotesPageState();
}

class _MyVotesPageState extends State<MyVotesPage> {
  static List<String> _songs = [
    "These",
    "Songs",
    "Don't",
    "Actually",
    "Search"
  ];
  List<Widget> _selectedList = List.empty();
  List<Widget> _searchList = List.empty();
  Timer? _searchDelay;

  bool _isSearching = false;
  late FocusNode _searchFocusNode;

  @override
  initState() {
    super.initState();
    this._searchFocusNode = FocusNode();
    _searchFocusNode.addListener(() {
      setState(() {
        _isSearching = _searchFocusNode.hasPrimaryFocus;
      });
    });
  }

  void _reorderList(int oldIndex, int newIndex) {
    var newList = [..._songs];
    var item = newList[oldIndex];
    newList.removeAt(oldIndex);
    newList.insert(newIndex, item);
  }

  void onSearchTextChanged(String text) {
    if (_searchDelay?.isActive == true) {
      _searchDelay!.cancel();
    }

    // Set a timeout delay to not spam the server
    _searchDelay =
        Timer(Duration(milliseconds: 500), () => searchForSongs(text));
  }

  void searchForSongs(String searchText) async {
    var response = await Search.search(searchText);

    // convert to widgets
    setState(() {
      _searchList = response.songs
          .map((song) => SongSearchItem(
                songName: song.name,
                artistName: song.artist,
                // Last artwork in the list is the smallest sized
                artworkUrl: song.artwork[1].url,
              ))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          AnimatedContainer(
            padding: _isSearching
                ? EdgeInsets.fromLTRB(5, 15, 5, 15)
                : EdgeInsets.fromLTRB(35, 15, 35, 15),
            curve: Curves.easeOutSine,
            duration: Duration(milliseconds: 300),
            child: TextFormField(
              onChanged: onSearchTextChanged,
              decoration: InputDecoration(
                suffixIcon: _isSearching
                    ? IconButton(
                        icon: Icon(Icons.cancel),
                        onPressed: () => _searchFocusNode.unfocus())
                    : null,
                labelText: "Search for songs",
                border: OutlineInputBorder(),
                isDense: true,
              ),
              focusNode: _searchFocusNode,
            ),
          ),
          SizedBox(height: 20),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: ListView(children: _searchList),
            ),
          ),
          // Expanded(
          //   child: ReorderableListView(
          //     onReorder: _reorderList,
          //     children: _selectedList,
          //   ),
          // ),
        ],
      ),
    );
  }
}
