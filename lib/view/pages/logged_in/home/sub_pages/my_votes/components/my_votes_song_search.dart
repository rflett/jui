import 'dart:async';

import 'package:flutter/material.dart';
import 'package:jui/server/search.dart';
import 'package:jui/view/components/material_autocomplete.dart';

class MyVotesSongSearch extends StatefulWidget {
  final AutocompleteOnSelected<String> _itemSelectedFn;
  List<String> _searchList;

  const MyVotesSongSearch(
      {Key? key, required AutocompleteOnSelected<String> itemSelectedFn})
      : this._itemSelectedFn = itemSelectedFn,
        super(key: key);

  @override
  _MyVotesSongSearchState createState() => _MyVotesSongSearchState();
}

class _MyVotesSongSearchState extends State<MyVotesSongSearch> {
  Timer? _searchDelay;
  Iterable<String> _songSearchFn(TextEditingValue value) {
    // Only search after a short delay to prevent spamming the API
    if (_searchDelay?.isActive == true) {
      // Cancel the previous search
      _searchDelay!.cancel();
    }

    // Start a new delay to search for the data
    // TODO link to search api

  }

  Future<List<String>> _searchSongs(String searchText) async {
    // Todo only search after a delay to prevent spamming the api
    // if (_searchDelay?.isActive == true) {
    //   // Cancel the previous search
    //   _searchDelay!.cancel();
    // }

    // Start a new search

    var response = await Search.search(searchText);

    return response.songs.map((e) => e.name).toList(growable: false);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialAutocomplete(
      optionsBuilder: _songSearchFn,
      labelText: "Search Songs",
    );
  }
}
