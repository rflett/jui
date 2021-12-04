import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/utilities/storage.dart';

class GroupState extends ChangeNotifier {
  GroupResponse? _selectedGroup;
  List<GroupResponse> _groups = List.empty();
  List<UserResponse> _selectedGroupMembers = List.empty();

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

  void setSelectedGroupById(String? newGroupId) {
    if (newGroupId == null) {
      // Need to have a group selected
      return;
    }

    final selectedGroup =
        _groups.firstWhere((group) => group.groupID == newGroupId);
    _selectedGroup = selectedGroup;
    notifyListeners();

    // Store for when the app is loaded again and update the members
    DeviceStorage.storeValue(storagePrimaryGroupId, newGroupId);
    _getSelectedGroupMembers();
  }

  void reloadGroupMembers() => _getSelectedGroupMembers();

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
