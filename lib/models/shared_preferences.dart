import 'dart:convert';
 
import 'package:shared_preferences/shared_preferences.dart';
 
class SharedPref {
  static Future setBool(String boolSharedPreference) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(boolSharedPreference, true);
  }
 
  // static Future<bool> getBool(bool value) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getBool(boolSharedPreference) ?? false;
  // }
 
  // static Future setListString(
  //     {required String id, required String token}) async {
  //   final prefs = await SharedPreferences.getInstance();
  //   prefs.setStringList(listSharedPreference, [id, token]);
  // }
 
  // static Future<List<String>> getListString() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   return prefs.getStringList(listSharedPreference) ?? [];
  // }
 
  static Future<String> getString(String listSharedPreference) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(listSharedPreference) ?? "";
  }
 /*
  static Future setString(String value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(stringSharedPreference, value);
  }
 
  static Future setInt(int val) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setInt(intSharedPreference, val);
  }
 
  static Future<int> getInt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(intSharedPreference) ?? 0;
  }
 
  static Future setDouble(double val) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setDouble(doubleSharedPreference, val);
  }
 
  static Future<double> getDouble() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getDouble(doubleSharedPreference) ?? 0.0;
  }
 
  static Future setMap(Map value) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.setString(mapSharedPreference, jsonEncode(value));
  }
 
  static Future<Map> getMap() async {
    final prefs = await SharedPreferences.getInstance();
    return jsonDecode(prefs.getString(mapSharedPreference) ?? "") ?? {};
  }
 
  static Future clearSharedPref() async {
    final prefs = await SharedPreferences.getInstance();
 
    await prefs.clear();
  }
  */
}