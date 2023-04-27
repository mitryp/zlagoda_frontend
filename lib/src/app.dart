import 'package:flutter/material.dart';

import 'services/auth/user.dart';
import 'theme.dart';
import 'view/main_viewport.dart';
import 'view/pages/login.dart';
import 'view/widgets/auth/user_provider.dart';

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
    return UserProvider(
      nestedNavigatorKey: globalNavigatorKey,
      child: MaterialApp(
        navigatorKey: globalNavigatorKey,
        debugShowCheckedModeBanner: false,
        title: 'Злагода',
        initialRoute: '/login',
        routes: {
          '/app': (context) => const MainViewport(),
          '/login': (context) => const LoginPage(),
        },
        theme: mainTheme,
      ),
    );
  }
}
