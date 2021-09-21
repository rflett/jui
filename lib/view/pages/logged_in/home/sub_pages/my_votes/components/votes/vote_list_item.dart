import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class VoteListItem extends StatelessWidget {
  final Vote vote;
  final int index;
  final Color color;

  const VoteListItem(
      {Key? key, required this.vote, required this.color, required this.index})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (vote.rank ?? 0) <= 10
          ? Theme.of(context).cardColor
          : Colors.grey.shade400,
      child: Padding(
        padding: EdgeInsets.all(15),
        child: Row(
          children: [
            Text(
              "#${vote.rank}",
              style: TextStyle(fontSize: 30),
            ),
            SizedBox(width: 20),
            ReorderableDragStartListener(
              index: index,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(vote.artwork.first.url),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 15),
                    Text(
                      vote.name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      vote.artist,
                      style: TextStyle(fontSize: 15),
                    )
                  ],
                ),
              ),
            ),
            IconButton(icon: Icon(Icons.delete_outlined, color: Colors.red), onPressed: () => {}),
            SizedBox(width: 10),
            ReorderableDragStartListener(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
                  child: Icon(Icons.drag_handle_rounded, color: Colors.grey),
                ),
                index: index,
            ),

          ],
        ),
      ),
    );
  }
}
