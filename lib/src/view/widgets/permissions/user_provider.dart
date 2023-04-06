import 'package:flutter/material.dart';

import '../../../services/auth/user.dart';
import 'user_manager.dart';

class UserProvider extends StatefulWidget {
  final GlobalKey<NavigatorState> nestedNavigatorKey;
  final Widget child;

  const UserProvider({
    required this.child,
    required this.nestedNavigatorKey,
    super.key,
  });

  @override
  State<UserProvider> createState() => _UserProviderState();
}

class _UserProviderState extends State<UserProvider> {
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return UserManager(
      currentUser: currentUser,
      userModificationCallback: setCurrentUser,
      loginRedirect: redirectToLogin,
      child: widget.child,
    );
  }

  void setCurrentUser(User? user) => setState(() => currentUser = user);

  void redirectToLogin() =>
      Navigator.of(widget.nestedNavigatorKey.currentContext!).pushReplacementNamed('/login');
}
