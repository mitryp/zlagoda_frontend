import 'package:flutter/material.dart';

import '../model/basic_models/employee.dart';
import '../services/http/helpers/http_service_helper.dart';
import '../services/middleware/request/authentication_middleware.dart';
import '../services/middleware/response/auth_handle_middleware.dart';
import '../services/middleware/response/response_display_middleware.dart';
import '../utils/json_decode.dart';
import '../utils/navigation.dart';
import 'app_pages.dart';
import 'widgets/middleware_context/request_middleware_context.dart';
import 'widgets/middleware_context/response_middleware_context.dart';
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
    return Authorizer.redirect(
      authorizationStrategy: hasUser,
      child: buildMainScaffold(),
    );
  }

  Widget buildMainScaffold() {
    return Scaffold(
      body: Row(
        children: [
          buildNavigationRail(),
          ResponseMiddlewareContext(
            middlewareBuilders: const [ResponseDisplayMiddleware.errors, AuthHandleMiddleware.new],
            child: RequestMiddlewareContext(
              middlewareBuilders: const [RequestAuthMiddleware.new],
              child: buildMainView(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildMainView() {
    return Expanded(
      child: ClipPath(
        child: Navigator(
          key: nestedNavigatorKey,
          initialRoute: AppPage.goods.route,
          onGenerateRoute: onGenerateNestedRoute,
        ),
      ),
    );
  }

  Widget buildNavigationRail() {
    return SizedBox(
      width: 150,
      child: NavigationRail(
        selectedIndex: AppPage.values.indexOf(currentPage),
        destinations: railDestinations,
        trailing: buildProfileLink(),
        onDestinationSelected: (index) {
          if (index == currentPageIndex) return;

          setState(() => currentPageIndex = index);
          Navigator.of(nestedNavigatorKey.currentContext!).pushNamed(currentPage.route);
        },
      ),
    );
  }

  Expanded buildProfileLink() {
    final userManager = UserManager.of(context);

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: ElevatedButton.icon(
            label: FittedBox(
              child: Text(userManager.currentUser?.name.firstName ?? 'No user'),
            ),
            icon: const Icon(Icons.account_circle),
            onPressed: () async {
              final user = await _fetchCurrentUser(context); // todo returns 404
              if (!mounted || user == null) return;
              AppNavigation.of(context).openModelViewFor<Employee>(user);
            },
          ),
        ),
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

Future<Employee?> _fetchCurrentUser(BuildContext context) async {
  if (UserManager.of(context).currentUser == null) return null;
  return _makeCurrentUserRequest();
}

Future<Employee?> _makeCurrentUserRequest() async {
  final res = await makeRequest(HttpMethod.get, Uri.http(baseRoute, 'api/employees/me'));

  return httpServiceController(
    res,
    (response) => Employee.fromJson(decodeResponseBody<Map<String, dynamic>>(response)),
    (response) => null,
  );
}
