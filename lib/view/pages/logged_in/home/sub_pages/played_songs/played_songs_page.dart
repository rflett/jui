import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/server/songs.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/view/pages/logged_in/components/animated_bar.dart';
import 'package:palette_generator/palette_generator.dart';

class PlayedSongsPage extends StatefulWidget {
  PlayedSongsPage({Key? key}) : super(key: key);

  @override
  _PlayedSongsPageState createState() => _PlayedSongsPageState();
}

class _PlayedSongsPageState extends State<PlayedSongsPage>
    with SingleTickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _animController;
  List<Vote> _songs = [];

  int _playedCount = 0;
  int _currentIndex = 0;
  int _startIndex = 0;
  int _numItems = 1; // if playedCount is less than 5 then no songs will get returned

  Color? currentColor;

  _PlayedSongsPageState() {
    _getData(0);
  }

  _getData(int currentIndex) async {
    try {
      var playedSongs = await Songs.getPlayed(_startIndex, _numItems);

      setState(() {
        this._songs = playedSongs.songs;
        this._playedCount = playedSongs.playedCount;
        this._currentIndex = currentIndex;
        this._numItems = min(this._playedCount, 5);
      });

      this._setAverageColor();
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _animController =
        AnimationController(vsync: this, duration: Duration(seconds: 5));

    _loadSong(animateToPage: false);

    _animController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animController.stop();
        _animController.reset();
        _moveForward();
      }
    });
  }

  @override
  void dispose() {
    this._pageController.dispose();
    this._animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return this._songs.length == 0 || this._playedCount == 0
        ? Container(
            color: Colors.greenAccent,
            child: Hero(
              tag: "login-logo",
              child: Image.asset(
                "assets/images/countdown.png",
                // width: 300,
              ),
            ),
          )
        : Scaffold(
            backgroundColor: currentColor,
            floatingActionButton: Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20, 15),
              child: FloatingActionButton(
                onPressed: () => _onSpotifyPressed(),
                child: ImageIcon(
                  AssetImage("assets/images/social/spotify-icon.png"),
                  size: 80,
                ),
                backgroundColor: Colors.green,
              ),
            ),
            body: GestureDetector(
              onTapDown: (details) => _onTapDown(details),
              child: Stack(
                children: <Widget>[
                  PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: this._songs.length,
                    itemBuilder: (context, i) {
                      final Vote song = this._songs[i];
                      return CachedNetworkImage(
                        imageUrl: song.artwork.first.url,
                        fit: BoxFit.contain,
                      );
                    },
                  ),
                  Positioned(
                    top: 5.0,
                    left: 5.0,
                    right: 5.0,
                    child: Visibility(
                        visible: _playedCount > 0,
                        child: Row(
                            children: List.generate(
                          _playedCount,
                          (index) => AnimatedBar(
                            animController: _animController,
                            position: index,
                            currentIndex: playedPosition - 1,
                          ),
                        ))),
                  ),
                  Positioned(
                      top: 20.0,
                      left: 10.0,
                      right: 10.0,
                      child: Column(
                        children: [
                          Container(
                            child: Text(this._songs[_currentIndex].name,
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 3.0)),
                            decoration: new BoxDecoration(color: Colors.black),
                            padding: new EdgeInsets.all(10.0),
                          ),
                          SizedBox(height: 10),
                          Container(
                            child: Text(this._songs[_currentIndex].artist,
                                style: TextStyle(
                                    color: Colors.white, letterSpacing: 3.0)),
                            decoration: new BoxDecoration(color: Colors.black),
                            padding: new EdgeInsets.all(10.0),
                          ),
                        ],
                      )),
                  Positioned(
                    bottom: 25.0,
                    left: 20.0,
                    child: Container(
                      child: Text(
                        playedPositionStr,
                        style: TextStyle(
                          color: Colors.white,
                          letterSpacing: 3.0,
                          fontSize: 40.0,
                        ),
                      ),
                      decoration: new BoxDecoration(color: Colors.black),
                      padding: new EdgeInsets.all(10.0),
                    ),
                  ),
                ],
              ),
            ));
  }

  void _onSpotifyPressed() async {
    // TODO open Spotify
  }

  int get playedPosition {
    if (this._songs.length > 0) {
      return this._songs[_currentIndex].playedPosition!;
    } else {
      return 1;
    }
  }

  String get playedPositionStr {
    if (this._songs.length > 0) {
      return "#${101 - playedPosition}";
    } else {
      return "";
    }
  }

  void _setAverageColor() async {
    if (this._songs.length == 0) {
      return;
    }
    CachedNetworkImageProvider currentImage = CachedNetworkImageProvider(
        this._songs[_currentIndex].artwork.first.url);
    final PaletteGenerator paletteGenerator =
        await PaletteGenerator.fromImageProvider(currentImage);
    setState(() {
      this.currentColor = paletteGenerator.dominantColor!.color;
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      // go back if the left third of the screen is tapped
      _moveBackward();
    } else {
      // go forward if the right two thirds of the screen is tapped
      _moveForward();
    }
  }

  void _moveForward() {
    setState(() {
      if (_currentIndex + 1 < this._songs.length) {
        _currentIndex += 1;
        _loadSong();
      } else if (_currentIndex + 1 == this._songs.length &&
          playedPosition < _playedCount) {
        // go get some more songs dude!
        _startIndex += 5;
        _getData(0);
        _loadSong();
      }
    });
  }

  void _moveBackward() {
    setState(() {
      if (_currentIndex - 1 >= 0) {
        _currentIndex -= 1;
        _loadSong();
      } else if (_currentIndex - 1 < 0 && playedPosition >= 5) {
        // go get some more songs dude!
        _startIndex -= 5;
        _getData(4);
        _loadSong();
      }
    });
  }

  void _loadSong({bool animateToPage = true}) {
    _animController.stop();
    _animController.reset();
    _animController.forward();
    if (animateToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
      this._setAverageColor();
    }
  }
}
