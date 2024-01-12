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

  Future<void> register(String name, String email, String password) async {
    isLoadingRegister = true;
    notifyListeners();

    await apiServices.register(name, email, password);
    isLoadingRegister = false;
    notifyListeners();
  }

  Future<bool> login(User user) async {
    isLoadingLogin = true;
    notifyListeners();

    final LoginData loginData =
        await apiServices.login(user.email!, user.password!);
    if (!loginData.error) {
      await authRepository.saveUser(user);
      await authRepository.login();
    }
    isLoggedIn = await authRepository.isLoggedIn();

    isLoadingLogin = false;
    notifyListeners();

    return isLoggedIn;
  }
}
