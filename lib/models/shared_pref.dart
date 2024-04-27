 
import 'package:shared_preferences/shared_preferences.dart';
 
class SharedPref {
  
  static Future setBool(String boolSharedPreference) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(boolSharedPreference, true);
  }
 
  static Future<String> getString(String listSharedPreference) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(listSharedPreference) ?? "";
  }
 
}