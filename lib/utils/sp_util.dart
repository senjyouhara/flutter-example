
import 'package:shared_preferences/shared_preferences.dart';

class SpUtil {
  SpUtil._();

  static Future<bool> setStringList(String key, List<String> value) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setStringList(key, value);
  }
  static Future<List<String>?> getStringList(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getStringList(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setBool(key, value);
  }
  static Future<bool?> getBool(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setInt(key, value);
  }
  static Future<int?> getInt(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getInt(key);
  }

  static Future<bool> setString(String key, String value) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setString(key, value);
  }
  static Future<String?> getString(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getString(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    final sp = await SharedPreferences.getInstance();
    return sp.setDouble(key, value);
  }
  static Future<double?> getDouble(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.getDouble(key);
  }

  static Future<dynamic?> getDynamic(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.get(key);
  }

  static Future<bool?> remove(String key) async {
    final sp = await SharedPreferences.getInstance();
    return sp.remove(key);
  }

  static Future<bool?> removeAll() async {
    final sp = await SharedPreferences.getInstance();
    return sp.clear();
  }

}