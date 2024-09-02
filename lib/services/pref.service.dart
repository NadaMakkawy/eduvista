import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class PreferencesService {
  static SharedPreferences? prefs;

  static Future<void> init() async {
    try {
      prefs = await SharedPreferences.getInstance();
      if (kDebugMode) {
        print('prefs is setup Successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize preferences: $e');
      }
    }
  }

  static bool get isOnBoardingSeen =>
      prefs!.getBool('isOnBoardingSeen') ?? false;

  static set isOnBoardingSeen(bool value) =>
      prefs!.setBool('isOnBoardingSeen', value);
}
