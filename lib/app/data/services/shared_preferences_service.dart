import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  static SharedPreferencesService? _instance;
  static late SharedPreferences _preferences;

  SharedPreferencesService._();

  static get instance {
    _instance ??= SharedPreferencesService._();

    return _instance!;
  }

  static Future<void> init() async =>
      _preferences = await SharedPreferences.getInstance();

  static String? getString(String key) => _preferences.getString(key);

  static int? getInt(String key) => _preferences.getInt(key);

  static double? getDouble(String key) => _preferences.getDouble(key);

  static bool? getBool(String key) => _preferences.getBool(key);

  static List<String>? getStringList(String key) =>
      _preferences.getStringList(key);

  static Future<void> saveString(String key, String value) async =>
      _preferences.setString(key, value);

  static Future<void> saveInt(String key, int value) async =>
      _preferences.setInt(key, value);

  static Future<void> saveDouble(String key, double value) async =>
      _preferences.setDouble(key, value);

  static Future<void> saveBool(String key, bool value) async =>
      _preferences.setBool(key, value);

  static Future<void> saveStringList(String key, List<String> value) async =>
      _preferences.setStringList(key, value);

  static void remove(String key) => _preferences.remove(key);
}
