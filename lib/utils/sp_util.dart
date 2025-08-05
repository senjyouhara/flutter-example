
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';


class SpUtil {

  SpUtil._internal();

  factory SpUtil() => _instance;

  static late final SpUtil _instance = SpUtil._internal();

  static late SharedPreferences _preferences;

// 需提前在程序入口调用该方法
  static Future<SpUtil> getInstance() async {
    _preferences = await SharedPreferences.getInstance();
    return _instance;
  }

  /// 根据key存储Map类型
  static Future<bool> setMap(String key, Map value) {
    return _preferences.setString(key, json.encode(value));
  }

  /// 根据key获取Map类型
  static Map<String, dynamic>? getMap(String key) {
    String jsonStr = _preferences.getString(key) ?? "";
    return jsonStr.isEmpty ? null : json.decode(jsonStr);
  }

  static Future<bool> setStringList(String key, List<String> value) async {
    return _preferences.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    return _preferences.getStringList(key);
  }

  static Future<bool> setBool(String key, bool value) async {
    return _preferences.setBool(key, value);
  }
  static Future<bool?> getBool(String key) async {
    return _preferences.getBool(key);
  }

  static Future<bool> setInt(String key, int value) async {
    return _preferences.setInt(key, value);
  }
  static Future<int?> getInt(String key) async {
    return _preferences.getInt(key);
  }

  static Future<bool> setString(String key, String value) async {
    return _preferences.setString(key, value);
  }
  static Future<String?> getString(String key) async {
    return _preferences.getString(key);
  }

  static Future<bool> setDouble(String key, double value) async {
    return _preferences.setDouble(key, value);
  }
  static Future<double?> getDouble(String key) async {
    return _preferences.getDouble(key);
  }

  static Future<dynamic?> getDynamic(String key) async {
    return _preferences.get(key);
  }

  static Future<bool?> remove(String key) async {
    return _preferences.remove(key);
  }

  static Future<bool?> removeAll() async {
    return _preferences.clear();
  }

  /// 重新加载所有数据,仅重载运行时
  static Future<void> reload() async {
    return await _preferences.reload();
  }


}