import 'package:shared_preferences/shared_preferences.dart';
import 'package:story_app_flutter_intermediate/model/user.dart';

class AuthRepository {
  final String stateKey = "state";

  Future<bool> isLoggedIn() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.getBool(stateKey) ?? false;
  }

  Future<bool> login() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, true);
  }

  Future<bool> logout() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setBool(stateKey, false);
  }

  //USER
  final String userKey = "user";

  Future<bool> saveUser(User user) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, user.toJson());
  }

  Future<bool> deleteUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(userKey, "");
  }

  Future<User?> getUser() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final json = preferences.getString(userKey) ?? "";
    User? user;
    try {
      user = User.fromJson(json);
    } catch (e) {
      user = null;
    }
    return user;
  }

  //Token
  final String tokenKey = "authToken";

  Future<bool> saveToken(String token) async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(tokenKey, token);
  }

  Future<bool> deleteToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    return preferences.setString(tokenKey, "");
  }

  Future<String> getToken() async {
    final preferences = await SharedPreferences.getInstance();
    await Future.delayed(const Duration(seconds: 2));
    final token = preferences.getString(tokenKey) ?? "";
    return token;
  }
}
