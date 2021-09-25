import 'package:flutter/material.dart';
import 'package:jui/view/components/content_list.dart';

class SongSearchList extends StatelessWidget {
  final List<Widget> searchList;

  const SongSearchList({Key? key, required this.searchList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ContentList(
          children: searchList,
          emptyView: Card(
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Flex(
                direction: Axis.horizontal,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [Text("Start searching for a song!")],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
