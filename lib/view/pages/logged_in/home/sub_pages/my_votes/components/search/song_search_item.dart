import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class SongSearchItem extends StatelessWidget {
  final Vote song;
  final ValueSetter<Vote> onClicked;
  final String songName;
  final String artistName;
  final String artworkUrl;

  SongSearchItem({Key? key, required this.song, required this.onClicked})
      : this.songName = song.name,
        this.artistName = song.artist,
        // Usually 3 artworks with middle one being the medium size
        this.artworkUrl = song.artwork[1].url,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: GestureDetector(
        onTap: () => onClicked(song),
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Row(
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(artworkUrl),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      songName,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      artistName,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
