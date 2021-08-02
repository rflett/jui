import 'dart:async';
import 'package:jui/models/enums/settings_page.dart';
import 'package:jui/services/base/messenger_service.dart';

class SettingsService extends MessengerService<ProfileEvents> {
  static SettingsService? _instance;

  SettingsService._internal() {
    messenger = StreamController.broadcast();
    messages = messenger.stream;
  }

  static SettingsService getInstance() {
    if (_instance == null) {
      _instance = SettingsService._internal();
    }
    return _instance!;
  }
}
