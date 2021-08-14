import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';

class VoteListItem extends StatelessWidget {
  final Vote vote;
  final Color color;

  const VoteListItem({Key? key, required this.vote, required this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: vote.rank != null && vote.rank! <= 10
          ? color
          : Theme.of(context).disabledColor,
      leading: Image.network(vote.artwork.last.url),
      title: Text("#${vote.rank} - ${vote.name}"),
    );
  }
}
