import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/user/create_vote.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/server/search.dart';
import 'package:jui/server/user.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/token.dart';

class VotesPage extends StatefulWidget {
  @override
  _VotesPageState createState() => _VotesPageState();
}

class _VotesPageState extends State<VotesPage> {
  String _searchStr = "";
  List<Vote> _votes = [];

  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }

  loadVotes() async {
    try {
      // retrieve the user id from the stored token
      var tkn = await Token.get();
      var user = await User.get(tkn.sub, withVotes: true);
      // get the user's votes
      this._votes = user.votes == null ? [] : user.votes!;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  createVote(int position, Vote vote) async {
    var requestData = CreateVoteRequest(position, vote);
    try {
      await User.createVote(requestData);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  removeVote(Vote vote) async {
    try {
      await User.removeVote(vote.songId);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  onTriggerSearch() {
    if (_formKey.currentState?.validate() == true) {
      var searchStr = "";
      // replace spaces with +
      searchStr = this._searchStr.replaceAll(" ", "+");
      // remove special chars
      searchStr = searchStr.replaceAll(new RegExp(r'[^a-zA-Z0-9 ]+'), '');
      try {
        var songs = Search.search(searchStr);
      } catch (err) {
        // TODO logging
        print(err);
        PopupUtils.showError(context, err as ProblemResponse);
      }
    }
  }
}
