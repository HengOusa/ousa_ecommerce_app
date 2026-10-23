import 'package:shared_preferences/shared_preferences.dart';

class PreferencesService {
  final SharedPreferences preferences;

  PreferencesService(this.preferences);

  String? getString(String key) => preferences.getString(key);

  Future<bool> setString(String key, String value) =>
      preferences.setString(key, value);

  bool? getBool(String key) => preferences.getBool(key);

  Future<bool> setBool(String key, bool value) =>
      preferences.setBool(key, value);

  int? getInt(String key) => preferences.getInt(key);

  Future<bool> setInt(String key, int value) => preferences.setInt(key, value);

  double? getDouble(String key) => preferences.getDouble(key);

  Future<bool> setDouble(String key, double value) =>
      preferences.setDouble(key, value);

  List<String>? getStringList(String key) => preferences.getStringList(key);

  Future<bool> setStringList(String key, List<String> value) =>
      preferences.setStringList(key, value);

  bool contains(String key) => preferences.containsKey(key);

  Set<String> getKeys() => preferences.getKeys();

  Future<bool> remove(String key) => preferences.remove(key);

  Future<bool> clear() => preferences.clear();

  Future<void> reload() => preferences.reload();
}
