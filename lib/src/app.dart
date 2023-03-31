import 'package:flutter/material.dart';

import 'view/main_viewport.dart';
import 'theme.dart';

class ZlagodaApplication extends StatelessWidget {
  const ZlagodaApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Злагода',
      initialRoute: '/app',
      routes: {
        '/app': (context) => const MainViewport(),
        // '/login': (context) => const MainViewport(),
      },
      theme: mainTheme,
    );
  }
}
