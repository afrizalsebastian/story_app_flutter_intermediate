import 'package:flutter/material.dart';
import 'package:story_app_flutter_intermediate/api/api_services.dart';
import 'package:story_app_flutter_intermediate/db/auth_repository.dart';
import 'package:story_app_flutter_intermediate/model/login.dart';
import 'package:story_app_flutter_intermediate/model/user.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository authRepository;
  final ApiServices apiServices;

  AuthProvider(this.authRepository, this.apiServices);

  bool isLoadingLogin = false;
  bool isLoadingLogout = false;
  bool isLoadingRegister = false;
  bool isLoggedIn = false;
  String errorLogin = '';
  String errorRegister = '';

  Future<bool> register(String name, String email, String password) async {
    try {
      isLoadingRegister = true;
      notifyListeners();

      await apiServices.register(name, email, password);
      isLoadingRegister = false;
      notifyListeners();

      return true;
    } on Exception catch (error) {
      errorRegister = error.toString().split(': ').last;

      isLoadingRegister = false;
      notifyListeners();

      return false;
    }
  }

  Future<bool> login(User user) async {
    try {
      isLoadingLogin = true;
      notifyListeners();

      final LoginData loginData =
          await apiServices.login(user.email!, user.password!);
      if (!loginData.error) {
        await authRepository.saveUser(user);
        await authRepository.saveToken(loginData.loginResult.token);
        await authRepository.login();
      }
      isLoggedIn = await authRepository.isLoggedIn();

      isLoadingLogin = false;
      notifyListeners();

      return isLoggedIn;
    } catch (error) {
      errorLogin = error.toString().split(': ').last;

      isLoadingLogin = false;
      notifyListeners();

      return isLoggedIn;
    }
  }

  Future<bool> logout() async {
    isLoadingLogout = true;
    notifyListeners();

    final logout = await authRepository.logout();
    if (logout) {
      await authRepository.deleteToken();
      await authRepository.deleteUser();
    }

    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogout = false;
    notifyListeners();

    return !isLoggedIn;
  }
}
