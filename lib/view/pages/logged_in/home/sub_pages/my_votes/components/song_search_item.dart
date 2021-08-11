import 'package:flutter/material.dart';

class SongSearchItem extends StatelessWidget {
  final String songName;
  final String artistName;
  final String artworkUrl;

  const SongSearchItem(
      {Key? key,
      required this.songName,
      required this.artistName,
      required this.artworkUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
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
    );
  }
}
