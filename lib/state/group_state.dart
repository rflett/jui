import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/models/dto/shared/vote.dart';
import 'package:jui/server/group.dart';

class GroupState extends ChangeNotifier {
  GroupResponse? _selectedGroup;
  List<GroupResponse> _groups = List.empty();
  List<UserResponse> _selectedGroupMembers = List.empty();

  /// An unmodifiable view of the votes in the cart.
  UnmodifiableListView<UserResponse> get members =>
      UnmodifiableListView(_selectedGroupMembers);

  GroupResponse? get selectedGroup => _selectedGroup;

  List<GroupResponse> get groups => _groups;

  void updateGroupList(List<GroupResponse> newList) {
    _groups = newList;
    notifyListeners();
  }

  void setSelectedGroup(GroupResponse newGroup) {
    _selectedGroup = newGroup;
    notifyListeners();
    _getSelectedGroupMembers();
  }

  // Updates the list of group members when the selected group is updated
  void _getSelectedGroupMembers() async {
    if (_selectedGroup != null) {
      try {
        var members =
            await Group.getMembers(_selectedGroup!.groupID, withVotes: true);
        _selectedGroupMembers = members.members;
        notifyListeners();
      } catch (err) {
        print(err);
      }
    }
  }
}
