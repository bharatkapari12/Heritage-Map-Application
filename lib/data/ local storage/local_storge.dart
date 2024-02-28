import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  Future savetoken({String? key, String? token}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString(key!, token!);
    // print(token);
  }

  Future<String?> gettoken({required String value}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var data = preferences.getString(value);
    return data;
  }

  Future clear({required String key}) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.remove(key);
  }
}
