import 'package:flutter/material.dart';

import '../../../services/auth/user.dart';

typedef UserModificationCallback = void Function(User? user);

/// [InheritedWidget] to track and control the current logged in user through the widget tree.
///
/// To provide the functionality of changing the user, this widget should be initialized in a
/// StatefulWidget, so the [currentUser] could be changed.
///
class UserManager extends InheritedWidget {
  final User? currentUser;
  final UserModificationCallback _userModificationCallback;
  final VoidCallback _loginRedirect;

  /// To provide the functionality of changing the user, this widget should be initialized in a
  /// StatefulWidget, so the given [currentUser] could be changed with the
  /// [userModificationCallback].
  ///
  /// [userModificationCallback] must be a function that changes the [currentUser] at the Stateful
  /// widget where it's defined.
  ///
  /// [loginRedirect] must be a function that opens the login page at the root navigator.
  ///
  /// For example:
  /// ```dart
  /// return UserManager(
  ///    currentUser: currentUser,
  ///    userModificationCallback: (user) => setState(() => currentUser = user),
  ///    loginRedirect: () => Navigator.of(context).pushReplacementNamed('/login'),
  ///    child: ...
  /// ```
  const UserManager({
    required this.currentUser,
    required UserModificationCallback userModificationCallback,
    required VoidCallback loginRedirect,
    required super.child,
    super.key,
  })
      : _userModificationCallback = userModificationCallback,
        _loginRedirect = loginRedirect;

  factory UserManager.of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<UserManager>()!;

  @override
  bool updateShouldNotify(UserManager oldWidget) => oldWidget.currentUser != currentUser;

  void setCurrentUser(User? newUser) => _userModificationCallback(newUser);

  void logout() => setCurrentUser(null);

  void redirectToLogin() => WidgetsBinding.instance.addPostFrameCallback((_) => _loginRedirect());
}
