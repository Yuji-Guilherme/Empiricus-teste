import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/features/articles/presentation/pages/home_page.dart';
import 'package:empiricus_test/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    refreshListenable: sl<AuthService>(),
    redirect: (BuildContext context, GoRouterState state) {
      final authService = sl<AuthService>();
      final isLoggedIn = authService.isLoggedIn;
      final isOnLoginPage = state.matchedLocation == login;

      if (!isLoggedIn && !isOnLoginPage) return login;

      if (isLoggedIn && isOnLoginPage) return home;

      return null;
    },
    routes: <GoRoute>[
      GoRoute(
        path: login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) =>
            const LoginPage(),
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
    ],
  );
}
