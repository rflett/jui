import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class VoteListItem extends StatelessWidget {
  final Vote vote;
  final int index;
  final Color color;
  final ValueSetter<int> onRemoved;

  const VoteListItem(
      {Key? key, required this.vote, required this.color, required this.index, required this.onRemoved})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: (vote.rank ?? 0) <= 10
          ? Theme.of(context).cardColor
          : Colors.grey.shade400,
      child: Padding(
        padding: EdgeInsets.fromLTRB(10, 5, 5, 5),
        child: Row(
          children: [
            Text(
              "#${index + 1}",
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(width: 10),
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
                        fontSize: 20,
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
            Column(
              children: [
                IconButton(icon: Icon(Icons.close, color: Colors.red), onPressed: () => onRemoved(index)),
                SizedBox(height: 30),
                ReorderableDragStartListener(
                  child: Icon(Icons.drag_handle_rounded, color: Colors.grey),
                  index: index,
                ),
                SizedBox(height: 5),
              ],
            ),

          ],
        ),
      ),
    );
  }
}