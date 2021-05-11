import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/group_response.dart';

class GroupDropDown extends StatefulWidget {
  final List<GroupResponse> groups;
  final void Function(String) onGroupSelected;

  GroupDropDown({Key? key, required this.groups, required this.onGroupSelected}) : super(key: key);

  @override
  _GroupDropDownState createState() => _GroupDropDownState(groups, onGroupSelected);
}

class _GroupDropDownState extends State<GroupDropDown> {
  // drop down menu item for selecting the current group
  List<DropdownMenuItem<String>> _selectedGroupOptions = [];
  // id of the currently selected group from the drop down
  String? _selectedGroupId;
  late void Function(String) _selectGroupCallback;

  _GroupDropDownState(List<GroupResponse> groups, Function(String) selectGroupCallback) {
    this._selectGroupCallback = selectGroupCallback;
    this._selectedGroupOptions = groups
        .map(
          (element) => DropdownMenuItem<String>(
            value: element.groupID,
            child: Text(element.name),
          ),
        )
        .toList();
    this.selectGroup(groups[0].groupID);
  }

  /// called when a group is selected from the drop down, updates the page data
  void selectGroup(String? groupId) {
    this._selectedGroupId = groupId;
    this._selectGroupCallback(groupId!);
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButton(
      value: _selectedGroupId,
      onChanged: (String? newValue) => selectGroup(newValue),
      items: _selectedGroupOptions,
    );
  }
}
