import 'package:flutter/material.dart';

import '../../../model/basic_models/employee.dart';
import '../../../services/auth/user.dart';
import 'user_manager.dart';

typedef UserAuthorizationStrategy = bool Function(User? user);

/// Widget that renders its child widget based on the current user from [UserManager] of
/// context and the [authorizationStrategy], which is a function of the nullable [User] object.
///
/// If the authorization is successful, the [child] widget is rendered.
/// Otherwise, depending on [isRedirectingToLogin], either the [unauthorizedPlaceholder] will be
/// rendered, or the [UserManager.redirectToLogin] will be called.
///
class Authorizer extends StatelessWidget {
  static const emptyPlaceholder = SizedBox();
  static const noPermissionPlaceholder = Center(
    child: Text(
      'У вас недостатньо прав для перегляду вмісту',
      style: TextStyle(
        fontSize: 16,
        color: Colors.red,
      ),
    ),
  );

  final UserAuthorizationStrategy authorizationStrategy;
  final Widget child;
  final Widget unauthorizedPlaceholder;
  final bool isRedirectingToLogin;

  const Authorizer({
    required this.child,
    this.authorizationStrategy = hasUser,
    this.unauthorizedPlaceholder = noPermissionPlaceholder,
    this.isRedirectingToLogin = false,
    super.key,
  });

  const Authorizer.emptyUnauthorized({
    required this.child,
    this.authorizationStrategy = hasUser,
    this.unauthorizedPlaceholder = emptyPlaceholder,
    this.isRedirectingToLogin = false,
    super.key,
  });

  const Authorizer.redirect({required this.child, this.authorizationStrategy = hasUser, super.key})
      : unauthorizedPlaceholder = emptyPlaceholder,
        isRedirectingToLogin = true;

  @override
  Widget build(BuildContext context) {
    final userManager = UserManager.of(context);

    if (authorizationStrategy(userManager.currentUser)) return child;
    if (isRedirectingToLogin) userManager.redirectToLogin();
    return unauthorizedPlaceholder;
  }
}

/// Returns true if the user is not null, i.e. any user is logged in.
///
bool hasUser(User? user) => user != null;

/// Returns true if the users position equals to the given [position].
///
UserAuthorizationStrategy hasPosition(Position position) => (user) => user?.role == position;
