import 'package:flutter/material.dart';

// A basic list that takes an array of widgets and a default widget to show if the list is empty
class ContentList extends StatelessWidget {
  final Widget? emptyView;
  final List<Widget> children;

  ContentList({required this.children, this.emptyView});

  @override
  Widget build(BuildContext context) {
    List<Widget> emptyList = emptyView != null ? [emptyView!] : List.empty();
    // TODO convert this over to an animatedList at some point
    return ListView(
      children: children.length > 0 ? children : emptyList,
    );
  }
}
