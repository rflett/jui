import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/request/group/create_update_group.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/problem_response.dart';
import 'package:jui/models/enums/events.dart';
import 'package:jui/server/group.dart';
import 'package:jui/services/settings_service.dart';
import 'package:jui/utilities/popups.dart';
import 'package:jui/utilities/validation.dart';

class CreateUpdateGroupPopup extends StatefulWidget {
  final GroupResponse? group;

  CreateUpdateGroupPopup({Key? key, this.group}) : super(key: key);

  @override
  _CreateUpdateGroupPopupState createState() =>
      _CreateUpdateGroupPopupState(this.group);
}

class _CreateUpdateGroupPopupState extends State<CreateUpdateGroupPopup> {
  GroupResponse? _group;
  String _title = "";
  String _actionBtnText = "";
  late SettingsService _service;

  // forms
  final _formKey = GlobalKey<FormState>();
  TextEditingController _name = new TextEditingController(text: "");

  _CreateUpdateGroupPopupState(GroupResponse? group) {
    if (group == null) {
      this._title = "Create new group";
      this._actionBtnText = "CREATE";
    } else {
      this._title = "Update group";
      this._actionBtnText = "UPDATE";
      this._name.text = group.name;
      this._group = group;
    }
    this._service = SettingsService.getInstance();
  }

  void _onAction() async {
    if (_formKey.currentState?.validate() != true) {
      return;
    }

    if (this._group == null) {
      this._createGroup(this._name.text);
    } else {
      this._updateGroup(this._name.text);
    }
  }

  void _createGroup(String name) async {
    var requestData = CreateUpdateGroupRequest(name);
    try {
      await Group.create(requestData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Created $name.")));
      Navigator.of(context).pop(true);
      // Send to singleton
      this._service.sendMessage(ProfileEvents.reloadGroups);
    } catch (err) {
      // TODO logging
      print(err);
      PopupUtils.showError(context, err as ProblemResponse);
    }
  }

  void _updateGroup(String name) async {
    var requestData = CreateUpdateGroupRequest(name);
    try {
      await Group.update(this._group!.groupID, requestData);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Updated $name.")));
      Navigator.of(context).pop(true);
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
          height: 80,
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
                      labelText: "Name \*",
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        TextButton(
          child: Text(this._actionBtnText),
          onPressed: () => this._onAction(),
        ),
      ],
    );
  }
}
