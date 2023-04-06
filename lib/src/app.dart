import 'package:flutter/material.dart';

import 'model/basic_models/employee.dart';
import 'model/common_models/name.dart';
import 'view/app_pages.dart';
import 'view/main_viewport.dart';
import 'theme.dart';
import 'view/pages/login.dart';
import 'view/pages/page_base.dart';
import 'services/auth/user.dart';
import 'view/widgets/permissions/user_manager.dart';

class ZlagodaApplication extends StatefulWidget {
  const ZlagodaApplication({super.key});

  @override
  State<ZlagodaApplication> createState() => _ZlagodaApplicationState();
}

class _ZlagodaApplicationState extends State<ZlagodaApplication> {
  final globalNavigatorKey = GlobalKey<NavigatorState>();
  User? currentUser;

  @override
  Widget build(BuildContext context) {
    return UserManager(
      currentUser: currentUser,
      userModificationCallback: (user) => setState(() => currentUser = user),
      loginRedirect: () {
        Navigator.of(globalNavigatorKey.currentContext!).pushReplacementNamed('/login');
      },
      child: MaterialApp(
        navigatorKey: globalNavigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Злагода',
        initialRoute: '/app',
        routes: {
          '/app': (context) => const MainViewport(),
          '/login': (context) => const LoginPage(),
        },
        theme: mainTheme,
      ),
    );
  }
}
