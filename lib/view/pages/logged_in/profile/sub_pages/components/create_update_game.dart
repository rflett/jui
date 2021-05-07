import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/group/games/create_update_game.dart';
import 'package:jui/models/dto/response/group/games/game_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/server/game.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/validation.dart';

class CreateUpdateGamePopup extends StatefulWidget {
  final String groupId;
  final GameResponse? game;
  CreateUpdateGamePopup({Key? key, required this.groupId, this.game}) : super(key: key);

  @override
  _CreateUpdateGamePopupState createState() =>
      _CreateUpdateGamePopupState(this.groupId, this.game);
}

class _CreateUpdateGamePopupState extends State<CreateUpdateGamePopup> {
  // others
  GameResponse? _game;
  String _groupId = "";
  String _title = "";
  String _actionBtnText = "";
  bool _deleteVisible = false;

  // forms
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController(text: "");
  TextEditingController _description = new TextEditingController(text: "");

  _CreateUpdateGamePopupState(String groupId, GameResponse? game) {
    this._groupId = groupId;
    if (game == null) {
      this._title = "Create game";
      this._actionBtnText = "CREATE";
      this._deleteVisible = false;
    } else {
      this._title = "Update game";
      this._actionBtnText = "UPDATE";
      this._deleteVisible = true;
      this._name.text = game.name;
      this._description.text = game.description;
      this._game = game;
    }
  }

  void _onAction(BuildContext context) async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    bool success;
    if (this._game == null) {
      success = await this._createGame(this._name.text, this._description.text);
    } else {
      success = await this._updateGame(this._name.text, this._description.text);
    }

    if (success == true) {
      Navigator.of(context).pop(true);
    }
  }

  Future<bool> _createGame(String name, String description) async {
    var requestData = CreateUpdateGameRequest(name, description);
    try {
      // TODO
      await Game.create(this._groupId, requestData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Created $name.")));
      return true;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
      return false;
    }
  }

  Future<bool> _updateGame(String name, String description) async {
    var requestData = CreateUpdateGameRequest(name, description);
    try {
      await Game.update(this._game!.groupID, this._game!.gameID, requestData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Updated $name.")));
      return true;
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
      return false;
    }
  }

  void _deleteGame() async {
    try {
      await Game.delete(this._game!.groupID, this._game!.gameID);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Successfully deleted game.")));
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(this._title),
      content: Form(
        key: _formKey,
        child: Container(
          width: 200,
          height: 200,
          child: ListView(
            children: [
              Wrap(
                runSpacing: 10,
                children: [
                  TextFormField(
                    controller: this._name,
                    keyboardType: TextInputType.name,
                    validator: validateRequired,
                    decoration: InputDecoration(
                        labelText: "Name \*", border: OutlineInputBorder()),
                  ),
                  TextFormField(
                    controller: this._description,
                    validator: validateRequired,
                    keyboardType: TextInputType.multiline,
                    minLines: 1,
                    maxLines: 4,
                    decoration: InputDecoration(
                        labelText: "Description \*", border: OutlineInputBorder()),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        Visibility(
          visible: _deleteVisible,
          child: IconButton(
              alignment: Alignment.centerLeft,
              icon: Icon(Icons.delete_outline_rounded, color: Colors.red),
              onPressed: () {
                _deleteGame();
                Navigator.of(context).pop(true);
              }),
        ),
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(this._actionBtnText),
          onPressed: () => this._onAction(context),
        ),
      ],
    );
  }
}
