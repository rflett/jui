import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/votes/vote_list_item.dart';

class VoteList extends StatefulWidget {
  final List<Vote> votes;
  void Function(List<Vote> toUpdate, List<Vote> toDelete) saveVotes;

  VoteList({Key? key, required this.votes, required this.saveVotes})
      : super(key: key);

  @override
  _VoteListState createState() => _VoteListState([...votes]);
}

class _VoteListState extends State<VoteList> {
  List<Vote> currentVotes;
  bool votesReordered = false;

  _VoteListState(this.currentVotes);

  get showControls =>
      votesReordered || currentVotes.length != widget.votes.length;

  // Reorder the elements in the array and store it inside the
  void reorderList(int oldIndex, int newIndex) {
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final votes = [...currentVotes];

    final item = votes.removeAt(oldIndex);
    votes.insert(newIndex, item);

    // Safe to assume that voting rank is the display order so re-rank all according to position
    List<Vote> newOrder = [];
    for (int i = 0; i < votes.length; i++) {
      newOrder.add(Vote.reordered(votes[i], i + 1));
    }

    setState(() {
      currentVotes = newOrder;
      votesReordered = true;
    });
  }

  // Resets the re-ordering of the list
  void resetList() {
    setState(() {
      currentVotes = [...widget.votes];
      votesReordered = false;
    });
  }

  void saveVotes() {
    final removed = widget.votes
        .where((vote) =>
            currentVotes.every((newVote) => newVote.songID != vote.songID))
        .toList();

    widget.saveVotes(currentVotes, removed);
    setState(() {
      votesReordered = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ReorderableListView(
          children: [
            for (int i = 0; i < currentVotes.length; i++)
              VoteListItem(
                key: Key(i.toString()),
                index: i,
                vote: currentVotes[i],
                color: i.isOdd
                    ? Theme.of(context).cardColor
                    : Theme.of(context).hoverColor,
              ),
          ],
          onReorder: reorderList,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: AnimatedOpacity(
            opacity: showControls ? 1 : 0,
            duration: Duration(milliseconds: 100),
            child: Column(
              children: [
                FloatingActionButton.extended(
                  onPressed: resetList,
                  backgroundColor: Theme.of(context).errorColor,
                  label: Text("Cancel"),
                  icon: Icon(Icons.cancel),
                ),
                SizedBox(height: 10),
                FloatingActionButton.extended(
                  onPressed: () => saveVotes(),
                  label: Text("Save"),
                  icon: Icon(Icons.save),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
