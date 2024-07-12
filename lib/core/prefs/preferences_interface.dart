abstract class PreferencesInterface {
  Future<void> init();

  Future<void> setString(String key, String value);

  Future<String?> getString(String key);

  Future<void> setBool(String key, bool value);

  Future<bool?> getBool(String key);
}
