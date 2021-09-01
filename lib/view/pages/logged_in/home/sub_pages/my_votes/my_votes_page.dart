import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/server/search.dart';
import 'package:jui/server/user.dart';
import 'package:jui/state/user_state.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/search/song_search_list.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/votes/vote_list.dart';
import 'package:provider/provider.dart';

import 'components/search/song_search_item.dart';

class MyVotesPage extends StatefulWidget {
  MyVotesPage({Key? key}) : super(key: key);

  @override
  _MyVotesPageState createState() => _MyVotesPageState();
}

class _MyVotesPageState extends State<MyVotesPage> {
  late FocusNode _searchFocusNode;
  late TextEditingController _inputController;
  Timer? _searchDelay;
  List<Widget> _searchList = List.empty();
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;
  List<Vote> _votes = List.empty();

  @override
  initState() {
    super.initState();
    getVotes();
    this._searchFocusNode = FocusNode();
    _searchFocusNode.addListener(onSearchFocusChanged);
    _inputController = TextEditingController();
    _inputController.addListener(onSearchTextChanged);
  }

  @override
  dispose() {
    _searchFocusNode.removeListener(onSearchFocusChanged);
    _inputController.removeListener(onSearchTextChanged);

    super.dispose();
  }

  get _isSearching => _crossFadeState == CrossFadeState.showSecond;

  void getVotes() async {
    final userProvider = Provider.of<UserState>(context, listen: false);

    if (userProvider.user != null) {
      // Get the user's votes
      try {
        final response = await User.getVotes(userProvider.user!.userID);
        setState(() {
          _votes = response.votes ?? [];
        });
        userProvider.updateVotes(_votes);
      } catch (err) {
        print(err);
      }
    }
  }

  void onSearchFocusChanged() {
    setState(() {
      if (_searchFocusNode.hasPrimaryFocus) {
        _crossFadeState = CrossFadeState.showSecond;
      } else {
        _crossFadeState = CrossFadeState.showFirst;
        _inputController.clear();
      }
    });
  }

  void onSearchTextChanged() {
    setState(() {});
    String text = _inputController.text;

    if (_searchDelay?.isActive == true) {
      _searchDelay!.cancel();
    }
    // Set a timeout delay to not spam the server
    _searchDelay =
        Timer(Duration(milliseconds: 500), () => searchForSongs(text));
  }

  void searchForSongs(String searchText) async {
    if (searchText.isEmpty) {
      // Don't search empty strings
      setState(() {
        _searchList = List.empty();
      });
      return;
    }

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

  // Send the updated votes to the server
  void saveVotes(List<Vote> toUpdate, List<Vote> toDelete) async {
    try {
      await User.updateVotes(toUpdate, toDelete);
    } catch (err) {
      print(err);
    }

    // Also retrieve the votes from the server again to update the local copy
    getVotes();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AnimatedContainer(
              padding: _isSearching
                  ? EdgeInsets.fromLTRB(5, 15, 5, 15)
                  : EdgeInsets.fromLTRB(35, 15, 35, 15),
              curve: Curves.easeOutSine,
              duration: Duration(milliseconds: 300),
              child: TextFormField(
                controller: _inputController,
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
              child: AnimatedCrossFade(
                firstChild: VoteList(
                  votes: _votes,
                  saveVotes: saveVotes,
                ),
                secondChild: SongSearchList(searchList: _searchList),
                crossFadeState: _crossFadeState,
                duration: Duration(milliseconds: 300),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
