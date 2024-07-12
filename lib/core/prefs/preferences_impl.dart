import 'package:fresh/core/prefs/preferences_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PreferencesImpl implements PreferencesInterface {
  SharedPreferences? _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> setString(String key, String value) async {
    await _prefs?.setString(key, value);
  }

  @override
  Future<String?> getString(String key) async {
    return _prefs?.getString(key);
  }

  @override
  Future<void> setBool(String key, bool value) async {
    await _prefs?.setBool(key, value);
  }

  @override
  Future<bool?> getBool(String key) async {
    return _prefs?.getBool(key);
  }
}
