import 'package:flutter/material.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/components/votes/vote_list_item.dart';
import 'package:jui/view/pages/logged_in/home/sub_pages/my_votes/state/VoteState.dart';
import 'package:provider/provider.dart';

class VoteList extends StatefulWidget {
  final VoidCallback saveVotes;

  VoteList({Key? key, required this.saveVotes}) : super(key: key);

  @override
  _VoteListState createState() => _VoteListState();
}

class _VoteListState extends State<VoteList> {
  // Reorder the elements in the array and store it inside the
  void reorderList(int oldIndex, int newIndex) {
    final voteState = Provider.of<VoteState>(context, listen: false);
    if (oldIndex < newIndex) {
      newIndex -= 1;
    }

    final votes = [...voteState.currentVotes];

    final item = votes.removeAt(oldIndex);
    votes.insert(newIndex, item);

    // Safe to assume that voting rank is the display order so re-rank all according to position
    List<Vote> newOrder = [];
    for (int i = 0; i < votes.length; i++) {
      newOrder.add(Vote.reordered(votes[i], i + 1));
    }

    voteState.reorderVotes(newOrder);
  }

  // Resets the re-ordering of the list
  void resetList() {
    final voteState = Provider.of<VoteState>(context, listen: false);
    voteState.resetVotes();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<VoteState>(
      builder: (context, voteState, child) => Stack(
        children: [
          ReorderableListView(
            children: [
              for (int i = 0; i < voteState.currentVotes.length; i++)
                Padding(
                  key: Key(i.toString()),
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: VoteListItem(
                    index: i,
                    onRemoved: voteState.removeVote,
                    vote: voteState.currentVotes[i],
                    color: i.isOdd
                        ? Theme.of(context).cardColor
                        : Theme.of(context).hoverColor,
                  ),
                ),
            ],
            onReorder: reorderList,
          ),
          Positioned(
            bottom: 20,
            right: 20,
            child: AnimatedOpacity(
              opacity: voteState.votesHaveChanged ? 1 : 0,
              duration: Duration(milliseconds: 100),
              child: Row(
                children: [
                  FloatingActionButton(
                    onPressed: resetList,
                    backgroundColor: Colors.grey,
                    child: Icon(Icons.cancel),
                  ),
                  SizedBox(width: 20),
                  FloatingActionButton(
                    onPressed: widget.saveVotes,
                    child: Icon(Icons.save),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
