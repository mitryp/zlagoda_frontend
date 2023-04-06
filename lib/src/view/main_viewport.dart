import 'package:flutter/material.dart';

import 'app_pages.dart';
import 'widgets/permissions/authorizer.dart';
import 'widgets/permissions/user_manager.dart';

class MainViewport extends StatefulWidget {
  const MainViewport({super.key});

  @override
  State<StatefulWidget> createState() => _MainViewportState();
}

class _MainViewportState extends State<MainViewport> {
  final nestedNavigatorKey = GlobalKey<NavigatorState>();

  int currentPageIndex = 0;

  AppPage get currentPage => AppPage.values[currentPageIndex];

  @override
  Widget build(BuildContext context) {
    return Authorizer.emptyUnauthorized(
      authorizationStrategy: hasUser,
      isRedirectingToLogin: true,
      child: Scaffold(
        body: Row(
          children: [
            buildNavigationRail(),
            buildMainView(),
          ],
        ),
      ),
    );
  }

  Expanded buildMainView() {
    return Expanded(
      child: Navigator(
        key: nestedNavigatorKey,
        initialRoute: AppPage.goods.route,
        onGenerateRoute: onGenerateNestedRoute,
        // todo transitionDelegate?
      ),
    );
  }

  NavigationRail buildNavigationRail() {
    return NavigationRail(
      selectedIndex: AppPage.values.indexOf(currentPage),
      destinations: railDestinations,
      trailing: FittedBox(
        child: Text('Current user:\n${UserManager.of(context).currentUser?.name.firstName}', textAlign: TextAlign.center,),
      ),
      onDestinationSelected: (index) {
        if (index == currentPageIndex) return;

        setState(() => currentPageIndex = index);
        Navigator.of(nestedNavigatorKey.currentContext!).pushNamed(currentPage.route);
      },
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
