import 'package:flutter/material.dart';
import 'package:jui/models/dto/response/group/group_response.dart';

class GroupDropdown extends StatelessWidget {
  final List<GroupResponse> groups;
  final void Function(String?) onGroupSelected;
  final String? selectedId;
  final bool? hideUnderline;
  final double? fontSize;

  const GroupDropdown(
      {required this.groups,
      required this.onGroupSelected,
      required this.selectedId,
      this.fontSize,
      this.hideUnderline,
      Key? key})
      : super(key: key);

  Widget buildDropdown(BuildContext context) {
    return DropdownButton(
      isExpanded: true,
      value: selectedId,
      style: TextStyle(fontSize: fontSize ?? 16, color: Theme.of(context).textTheme.button?.color),
      onChanged: (String? groupId) => onGroupSelected(groupId),
      items: groups
          .map((group) => DropdownMenuItem<String>(
                value: group.groupID,
                child: Text(group.name),
              ))
          .toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (hideUnderline == true) {
      return DropdownButtonHideUnderline(child: buildDropdown(context));
    } else {
      return buildDropdown(context);
    }
  }
}
