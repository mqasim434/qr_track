import 'package:qr_track/res/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SessionManagementService {
  static const String _emailKey = 'email';
  static const String _passwordKey = 'password';
  static const String _userType = 'userType';

  static Future<void> createSession(
      {required String email,
      required String password,
      required UserRoles userRole}) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(_emailKey, email);
    await prefs.setString(_passwordKey, password);
    await prefs.setString(_userType, userRole.name);
  }

  static Future<Map<String, dynamic>> checkSession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? email = prefs.getString(_emailKey);
    final String? password = prefs.getString(_passwordKey);
    final String? userType = prefs.getString(_userType);

    return {
      'email': email,
      'password': password,
      'userType': userType,
    };
  }

  static Future<void> destroySession() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }
}
