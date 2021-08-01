import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  int _currentIndex = 0;
  Color currentColor = Colors.black;

  _PlayedSongsPageState() {
    _getData();
  }

  _getData() async {
    try {
      var playedSongs = await Songs.getPlayed();

      setState(() {
        this._songs = playedSongs.songs;
      });

      _setAverageColor();
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
        setState(() {
          if (_currentIndex + 1 < this._songs.length) {
            _currentIndex += 1;
            _loadSong();
          } else {
            _currentIndex = 0;
            _loadSong();
          }
        });
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
    return Scaffold(
        backgroundColor: currentColor,
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
                      imageUrl: song.artwork[0].url,
                      fit: BoxFit.contain,
                    );
                  }),
              Positioned(
                top: 5.0,
                left: 5.0,
                right: 5.0,
                child: Row(
                  children: this
                      ._songs
                      .asMap()
                      .map((i, e) {
                        return MapEntry(
                          i,
                          AnimatedBar(
                            animController: _animController,
                            position: i,
                            currentIndex: _currentIndex,
                          ),
                        );
                      })
                      .values
                      .toList(),
                ),
              )
            ],
          ),
        ));
  }

  void _setAverageColor() async {
    CachedNetworkImageProvider currentImage = CachedNetworkImageProvider(this._songs[_currentIndex].artwork[0].url);
    final PaletteGenerator paletteGenerator = await PaletteGenerator
        .fromImageProvider(currentImage);
    setState(() {
      this.currentColor = paletteGenerator.dominantColor!.color;
    });
  }

  void _onTapDown(TapDownDetails details) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final double dx = details.globalPosition.dx;

    if (dx < screenWidth / 3) {
      // go back if the left third of the screen is tapped
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
          _loadSong();
        }
      });
    } else {
      // go forward if the right two thirds of the screen is tapped
      setState(() {
        if (_currentIndex + 1 < this._songs.length) {
          _currentIndex += 1;
          _loadSong();
        } else {
          // reached the end so go back to the start
          _currentIndex = 0;
          _loadSong();
        }
      });
    }
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
    }
    this._setAverageColor();
  }
}
