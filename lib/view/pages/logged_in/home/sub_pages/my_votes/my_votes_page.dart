import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/server/search.dart';
import 'package:jui/server/user.dart';
import 'package:jui/state/user_state.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/search/song_search_list.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/votes/vote_list.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/state/VoteState.dart';
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
  VoteState _voteState = VoteState();

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

  bool get _isSearching => _crossFadeState == CrossFadeState.showSecond;

  void getVotes() async {
    _voteState.setLoading();

    final userState = Provider.of<UserState>(context, listen: false);

    if (userState.user != null) {
      // Get the user's votes
      try {
        final response = await User.getVotes(userState.user!.userID);
        _voteState.setVotes(response.votes ?? []);
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
          .map((song) => SongSearchItem(song: song, onClicked: addSongToList))
          .toList();
    });
  }

  void addSongToList(Vote song) {
    setState(() {
      _inputController.clear();
      _crossFadeState = CrossFadeState.showFirst;
      _voteState.addSongFromSearch(song);
      _searchFocusNode.unfocus();
    });
  }

  // Send the updated votes to the server
  void saveVotes() async {
    final currentAndRemoved = _voteState.getCurrentAndRemoved(max: 10);
    _voteState.setLoading();

    try {
      await User.updateVotes(currentAndRemoved.item1, currentAndRemoved.item2);
    } catch (err) {
      print(err);
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Something went wrong, please try again")));
      return;
    }

    // Also retrieve the votes from the server again to update the local copy
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Votes updated successfully")));
    getVotes();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            AnimatedContainer(
              padding: EdgeInsets.all(15),
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
                ),
                focusNode: _searchFocusNode,
              ),
            ),
            Expanded(
              child: AnimatedCrossFade(
                firstChild: ChangeNotifierProvider<VoteState>(
                  create: (builder) => _voteState,
                  child: VoteList(
                    saveVotes: saveVotes,
                  ),
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
