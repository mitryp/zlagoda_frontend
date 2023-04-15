import 'services/auth/auth_service.dart';

const authServiceStrategy = String.fromEnvironment('auth_strategy', defaultValue: 'api') == 'api'
    ? AuthRouteStrategy.api
    : AuthRouteStrategy.mock;
