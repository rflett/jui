import 'package:flutter/material.dart';
import 'package:jui/view/components/content_list.dart';

class VoteList extends StatefulWidget {
  VoteList({Key? key}) : super(key: key);

  @override
  _VoteListState createState() => _VoteListState();
}

class _VoteListState extends State<VoteList> {
  @override
  Widget build(BuildContext context) {
    return ContentList(
      children: [],
      emptyView: Card(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Flex(
            direction: Axis.horizontal,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("You haven't voted for a song yet. Try searching for one")
            ],
          ),
        ),
      ),
    );
  }
}
