import 'package:flutter/material.dart';

class SnackbarCleanerObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    _clearSnackBars(route.navigator?.context);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPop(route, previousRoute);
    _clearSnackBars(previousRoute?.navigator?.context);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    super.didReplace(newRoute: newRoute, oldRoute: oldRoute);
    _clearSnackBars(newRoute?.navigator?.context);
  }

  void _clearSnackBars(BuildContext? context) {
    if (context != null) {
      ScaffoldMessenger.of(context).clearSnackBars();
    }
  }
}
