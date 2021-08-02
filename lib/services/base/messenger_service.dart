import 'dart:async';

import 'package:flutter/cupertino.dart';

abstract class MessengerService<TMessageType> {
  @protected
  late StreamController<TMessageType> messenger;
  late Stream<TMessageType> messages;

  void sendMessage(TMessageType message) {
    messenger.add(message);
  }
}