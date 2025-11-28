import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static final LocalStorage _instance = LocalStorage._internal();
  late final SharedPreferences _prefs;

  // factory LocalStorage() {
  //   return _instance;
  // }

  String? getString(String key) {
    return _prefs.getString(key);
  }

  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static LocalStorage get instance => _instance;

  LocalStorage._internal();
}
