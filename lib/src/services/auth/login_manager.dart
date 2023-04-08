import 'dart:async';

import 'package:flutter/material.dart';

import '../../utils/secure_storage.dart' as storage;
import '../../view/widgets/permissions/user_manager.dart';
import 'auth_service.dart';
import 'user.dart';

class LoginManager {
  final BuildContext context;
  final AuthService authService = const AuthService();

  const LoginManager.of(this.context);

  Future<AuthorizedUser?> get loginData => storage.getLoginData();

  UserManager get userManager => UserManager.of(context);

  void _setCurrentUser(User? user) {
    if (context.mounted) userManager.setCurrentUser(user);
  }

  Future<bool> login(String username, String password) async {
    final authorizedUser = await authService.login(username, password);

    if (authorizedUser == null) return false;

    await storage.setLoginData(authorizedUser.user, authorizedUser.token);
    _setCurrentUser(authorizedUser.user);
    return true;
  }

  Future<void> clearLoginData() {
    _setCurrentUser(null);
    return storage.clearLoginData();
  }

  Future<bool> authorizeCachedUser() async {
    final cachedData = await loginData;

    if (cachedData != null && await authService.validateToken(cachedData.token)) {
      _setCurrentUser(cachedData.user);
      return true;
    }

    return false;
  }
}
