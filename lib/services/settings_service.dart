import 'dart:async';

import 'package:jui/models/enums/social_providers.dart';

class SettingsService {
  static SettingsService? _instance;

  late StreamController<SocialProviders> _messenger;
  late Stream<SocialProviders> messages;

  SettingsService._internal() {
    _messenger = StreamController();
    messages = _messenger.stream;
  }

  static SettingsService getInstance() {
    if (_instance == null) {
      _instance = SettingsService._internal();
    }

    return _instance!;
  }

  void sendMessage(SocialProviders message) {
    _messenger.add(message);
  }
}
