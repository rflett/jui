import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:tuple/tuple.dart';

class VoteState extends ChangeNotifier {
  List<Vote> _originalVotes = List.empty();
  List<Vote> _currentVotes = List.empty();
  bool _hasAddedVote = false;
  bool _hasReorderedVotes = false;
  bool _isLoading = false;

  bool get votesHaveChanged => _hasAddedVote || _hasReorderedVotes;

  bool get isLoading => _isLoading;

  // The current votes, including user re-ordering and added songs via search
  UnmodifiableListView<Vote> get currentVotes =>
      UnmodifiableListView(_currentVotes);

  /// Returns the currently active votes as well as the removed ones.
  /// Set [max] to indicate how many votes to keep in the current list. Defaults to 10
  Tuple2<List<Vote>, List<Vote>> getCurrentAndRemoved({int max = 10}) {
    int length = _currentVotes.length < max ? _currentVotes.length : max;
    final currentList = _currentVotes.getRange(0, length);
    final removed = _originalVotes
        .where((vote) =>
            currentList.every((newVote) => newVote.songID != vote.songID))
        .toList();

    // Finally assign ranks to each item in the list based on their order
    List<Vote> rankedVotes = [];
    for (int i = 0; i < currentList.length; i++) {
      rankedVotes.add(Vote.reordered(currentList.elementAt(i), i + 1));
    }

    return Tuple2(rankedVotes, removed);
  }

  /// Update whether something related to votes is sending a network request
  void setLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// Set main votes list from the server
  setVotes(List<Vote> votes) {
    _originalVotes = [...votes];
    _currentVotes = [...votes];
    _hasReorderedVotes = false;
    _hasAddedVote = false;
    _isLoading = false;
    notifyListeners();
  }

  /// Add a new vote from the search list
  addSongFromSearch(Vote vote) {
    _currentVotes = [..._currentVotes, vote];
    _hasAddedVote = true;
    notifyListeners();
  }

  /// Reorder the votes in the visible list into something new
  reorderVotes(List<Vote> newOrder) {
    _currentVotes = [...newOrder];
    _hasReorderedVotes = true;
    notifyListeners();
  }

  /// Reset the order of the votes and removes added items from search
  resetVotes() {
    _currentVotes = [..._originalVotes];
    _hasReorderedVotes = false;
    _hasAddedVote = false;
    notifyListeners();
  }
}
