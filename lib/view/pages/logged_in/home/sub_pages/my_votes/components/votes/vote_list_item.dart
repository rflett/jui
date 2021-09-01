import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class VoteListItem extends StatelessWidget {
  final Vote vote;
  final int index;
  final Color color;

  const VoteListItem({Key? key, required this.vote, required this.color, required this.index})
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
            ReorderableDragStartListener(
              index: index,
              child: SizedBox(
                width: 100,
                height: 100,
                child: Image.network(vote.artwork.last.url),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: 100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      vote.name,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      vote.artist,
                      style: TextStyle(fontSize: 12),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
