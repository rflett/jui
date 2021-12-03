import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jui/models/dto/response/played_songs_response.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/server/songs.dart';

class PlayedSongState extends ChangeNotifier {
  List<Vote> _songs = List.empty();

  UnmodifiableListView<Vote> get songs => UnmodifiableListView(_songs);

  Future getSongs() async {
    PlayedSongsResponse playedSongs;
    try {
      playedSongs = await Songs.getPlayed();
    } catch (err) {
      print(err);
      return;
    }

    _songs = playedSongs.songs;
    notifyListeners();
  }
}
