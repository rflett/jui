import 'dart:async';

import 'package:jui/models/dto/response/group/group_response.dart';

import 'base/messenger_service.dart';

class GroupService extends MessengerService<GroupResponse?> {
  static GroupService? _instance;

  GroupService._internal() {
    messenger = StreamController.broadcast();
    messages = messenger.stream;
  }

  static GroupService getInstance() {
    if (_instance == null) {
      _instance = GroupService._internal();
    }
    return _instance!;
  }
}
