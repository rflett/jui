import 'dart:collection';

import 'package:flutter/widgets.dart';
import 'package:jui/constants/storage_values.dart';
import 'package:jui/constants/urls.dart';
import 'package:jui/models/dto/response/group/group_response.dart';
import 'package:jui/models/dto/response/user/user.dart';
import 'package:jui/server/group.dart';
import 'package:jui/utilities/storage.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:async/async.dart';

class GroupState extends ChangeNotifier {
  GroupResponse? _selectedGroup;
  List<GroupResponse> _groups = List.empty();
  List<UserResponse> _selectedGroupMembers = List.empty();
  List<WebSocketChannel> _websockets = const [];
  StreamGroup? _socketGroups;
  Stream? get webSockets => _socketGroups?.stream.asBroadcastStream();

  UnmodifiableListView<UserResponse> get members =>
      UnmodifiableListView(_selectedGroupMembers);

  GroupResponse? get selectedGroup => _selectedGroup;

  List<GroupResponse> get groups => _groups;

  void updateGroupList(List<GroupResponse> newList) {
    _groups = newList;
    _updateSocketConnections();
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

  void _updateSocketConnections() {
    _disconnectFromSockets();
    _connectToGroupSockets();
  }

  void _connectToGroupSockets() {
    List<Stream> sockets = [];
    for (var group in _groups) {
      var socket = WebSocketChannel.connect(
          Uri.parse("$socketBaseUrl/connect/${group.groupID}"));
      _websockets.add(socket);
      sockets.add(socket.stream);
      _socketGroups?.add(socket.stream);

    }
  }

  void _disconnectFromSockets() {
    for (var socket in _websockets) {
      socket.sink.close();
    }
    _websockets = [];
    _socketGroups = StreamGroup.broadcast();
  }
}
