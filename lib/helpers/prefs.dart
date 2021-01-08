import 'package:flutter_fire_chat/helpers/preferences_helper.dart';
import 'package:flutter_fire_chat/utils/util_constants.dart';

class Prefs {
  static Future<String> get userId => PreferencesHelper.getString(User_ID);

  static setUserId(String value) => PreferencesHelper.setString(User_ID, value);

  static Future<String> get userEmail => PreferencesHelper.getString(User_Email);

  static setUserEmail(String value) => PreferencesHelper.setString(User_Email, value);

  static Future<String> get userDisplayName => PreferencesHelper.getString(User_DisplayName);

  static setUserDisplayName(String value) => PreferencesHelper.setString(User_DisplayName, value);

  Future<void> clear() async {
    await PreferencesHelper.clearPrefs();
  }
}
