import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static final Session _instance = Session._internal();

  SharedPreferences? _prefs;

  factory Session() {
    return _instance;
  }

  Session._internal() {
    initSharedPreferences();
  }

  Future<void> initSharedPreferences() async {
    _prefs = await SharedPreferences.getInstance();
  }

   Future<void> setSession(String key, dynamic value) async {
    if (_prefs != null) {
      if (value is String) {
        await _prefs!.setString(key, value);
      } else if (value is int) {
        await _prefs!.setInt(key, value);
      } else if (value is bool) {
        await _prefs!.setBool(key, value);
      } else if (value is double) {
        await _prefs!.setDouble(key, value);
      }
    }
  }

  Future<dynamic> getSession(String key) async {
    if (_prefs != null) {
      return _prefs!.get(key);
    }
    return null;
  }

  Future<void> removeSession(String key) async {
    if (_prefs != null) {
      await _prefs!.remove(key);
    }
  }
}