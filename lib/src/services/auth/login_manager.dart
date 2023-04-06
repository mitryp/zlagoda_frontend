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

  Future<User?> login(String username, String password) async {
    final authorizedUser = await authService.login(username, password);

    if (authorizedUser == null) return null;

    await storage.setLoginData(authorizedUser.user, authorizedUser.token);
    if (context.mounted)
      UserManager.of(context).setCurrentUser(authorizedUser.user);

    return authorizedUser.user;
  }

  Future<void> clearLoginData() => storage.clearLoginData();
}
