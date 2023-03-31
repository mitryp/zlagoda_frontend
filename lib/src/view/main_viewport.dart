import 'package:flutter/material.dart';

import 'app_pages.dart';

class MainViewport extends StatefulWidget {
  const MainViewport({super.key});

  @override
  State<StatefulWidget> createState() => _MainViewportState();
}

class _MainViewportState extends State<MainViewport> {
  int currentPageIndex = 0;
  final nestedNavigatorKey = GlobalKey<NavigatorState>();

  AppPage get currentPage => AppPage.values[currentPageIndex];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            selectedIndex: AppPage.values.indexOf(currentPage),
            destinations: railDestinations,
            onDestinationSelected: (index) {
              if (index == currentPageIndex) return;

              setState(() => currentPageIndex = index);
              Navigator.of(nestedNavigatorKey.currentContext!).pushNamed(currentPage.route);
            },
          ),
          Expanded(
            child: Navigator(
              key: nestedNavigatorKey,
              initialRoute: AppPage.goods.route,
              onGenerateRoute: onGenerateNestedRoute,
              // todo transitionDelegate
            ),
          )
        ],
      ),
    );
  }

  Route<dynamic>? onGenerateNestedRoute(RouteSettings settings) {
    final targetPage = AppPage.values.firstWhere(
      (e) => e.route == settings.name?.toLowerCase(),
      orElse: () => AppPage.goods,
    );

    return MaterialPageRoute<void>(builder: targetPage.widget, maintainState: true);
  }

  List<NavigationRailDestination> get railDestinations {
    return AppPage.values
        .map((dest) => NavigationRailDestination(
              icon: Icon(dest.iconData),
              label: Text(dest.label),
            ))
        .toList();
  }
}
