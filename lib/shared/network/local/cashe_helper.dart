import 'package:shared_preferences/shared_preferences.dart';

class CasheHelper {
  static late SharedPreferences sharedPreference;
  static Future<SharedPreferences> init() async {
    return sharedPreference = await SharedPreferences.getInstance();
  }

  static Future<bool> putboolean(
      {required String key, required bool value}) async {
    return await sharedPreference.setBool(key, value);
  }

  static bool? getboolean({
    required String key,
  }) {
    return sharedPreference.getBool(key);
  }

  static Future<bool> saveData(
      {required String key, required dynamic value}) async {
    if (value is bool) return await sharedPreference.setBool(key, value);
    if (value is String) return await sharedPreference.setString(key, value);
    if (value is int) return await sharedPreference.setInt(key, value);

    return await sharedPreference.setDouble(key, value);
  }

  static dynamic getData({required String key}) {
    return sharedPreference.get(key);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreference.remove(key);
  }
}
