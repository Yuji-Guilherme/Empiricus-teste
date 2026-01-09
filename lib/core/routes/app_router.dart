import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';

  static final GoRouter router = GoRouter(
    initialLocation: login,
    routes: <GoRoute>[
      GoRoute(
        path: login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Login')));
        },
      ),
      GoRoute(
        path: home,
        name: 'home',
        builder: (BuildContext context, GoRouterState state) {
          return const Scaffold(body: Center(child: Text('Home')));
        },
      ),
    ],
  );
}
