import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Stores a string value in the most secure storage on the current platform
abstract class DeviceStorage {
  static Future<void> storeValue(String key, String value) async {
    if (kIsWeb) {
      // Store in the local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString(key, value);
    } else {
      // On other platforms store in secure storage
      var storage = FlutterSecureStorage();
      await storage.write(key: key, value: value);
    }
  }

  /// Retrieves a string value from secure storage, will return null if not present
  static Future<String?> retrieveValue(String key) async {
    if (kIsWeb) {
      // Store in the local storage
      SharedPreferences prefs = await SharedPreferences.getInstance();
      try {
        return prefs.getString(key);
      } catch (error) {
        return null;
      }
    } else {
      // On other platforms store in secure storage
      var storage = FlutterSecureStorage();
      return await storage.read(key: key);
    }
  }
}