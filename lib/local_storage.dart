import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static const _keyIsLoggedIn = 'isLoggedIn';
  static const _username = 'username';
  static const _password = 'password';

  // Save login state
  static Future<void> setLoggedIn(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, value);
  }

  // Load login state
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyIsLoggedIn) ?? false;
  }

  // Reset login state (for testing / logout)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyIsLoggedIn, false);
  }

  // Create a new account
  static Future<void> createAccount(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_username, username);
    await prefs.setString(_password, password);
    await setLoggedIn(true);
  }

  // Login with existing account
  static Future<bool> login(String username, String password) async {
    final prefs = await SharedPreferences.getInstance();
    String? storedUsername = prefs.getString(_username);
    String? storedPassword = prefs.getString(_password);

    if (storedUsername == username && storedPassword == password) {
      await setLoggedIn(true);
      return true;
    }

    return false;
  }

  // Get Login Credentials
  static Future<String> getLoginUsername() async {
    final prefs = await SharedPreferences.getInstance();
    String? username = prefs.getString(_username);
    return username ?? '';
  }

  static Future<String> getLoginPassword() async {
    final prefs = await SharedPreferences.getInstance();
    String? password = prefs.getString(_password);
    return password ?? '';
  }
}
