import 'dart:async';

import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/models/enums/social_providers.dart';

class SettingsService {
  static SettingsService? _instance;

  late StreamController<ProfileEvents> _messenger;
  late Stream<ProfileEvents> messages;

  SettingsService._internal() {
    _messenger = StreamController.broadcast();
    messages = _messenger.stream;
  }

  static SettingsService getInstance() {
    if (_instance == null) {
      _instance = SettingsService._internal();
    }

    return _instance!;
  }

  void sendMessage(ProfileEvents message) {
    _messenger.add(message);
  }
}
