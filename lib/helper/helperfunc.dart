import 'package:shared_preferences/shared_preferences.dart';

class helperfunc {
  static String loginkey = 'LOGGEDINKEY';
  static String namekey = 'USERNAMEKEY';
  static String emailkeu = 'EMAILKEY';

  static Future<bool> saveUserLoggedInStatus(bool insUserLoggedIn) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setBool(loginkey, insUserLoggedIn);
  }

  static Future<bool> saveUserNamesf(String name) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(namekey, name);
  }

  static Future<bool> saveUserEmailsf(String email) async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return await sf.setString(emailkeu, email);
  }

  static Future<bool?> getUserLoggedInStatus() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getBool(loginkey);
  }

  static Future<String?> getUsername() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(namekey);
  }

  static Future<String?> getUseremail() async {
    SharedPreferences sf = await SharedPreferences.getInstance();
    return sf.getString(emailkeu);
  }
}
