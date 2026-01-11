import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/core/utils/snackbar_observer.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/features/articles/presentation/pages/details_page.dart';
import 'package:empiricus_test/features/articles/presentation/pages/home_page.dart';
import 'package:empiricus_test/features/auth/presentation/pages/login_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static const String home = '/';
  static const String login = '/login';
  static const String details = '/:slug';

  static final GoRouter router = GoRouter(
    initialLocation: home,
    refreshListenable: sl<AuthService>(),
    observers: [SnackbarCleanerObserver()],
    routes: <GoRoute>[
      GoRoute(
        path: login,
        name: 'login',
        builder: (BuildContext context, GoRouterState state) {
          final from = state.uri.queryParameters['from'];
          return LoginPage(redirectUrl: from);
        },
      ),
      GoRoute(
        path: home,
        name: 'home',
        redirect: (context, state) {
          final authService = sl<AuthService>();
          if (!authService.isLoggedIn) return '/login';

          return null;
        },
        builder: (BuildContext context, GoRouterState state) =>
            const HomePage(),
      ),
      GoRoute(
        path: details,
        name: 'details',
        redirect: (context, state) {
          final authService = sl<AuthService>();
          if (!authService.isLoggedIn) {
            final originalUrl = state.uri.toString();

            return '/login?from=${Uri.encodeComponent(originalUrl)}';
          }

          return null;
        },
        builder: (context, state) {
          final slug = state.pathParameters['slug']!;
          final article = state.extra as ArticleModel?;

          return DetailsPage(slug: slug, article: article);
        },
      ),
    ],
  );
}
