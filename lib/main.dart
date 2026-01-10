import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/routes/app_router.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/core/theme/app_theme.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  setupServiceLocator();
  await sl<AuthService>().checkLoginStatus();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Empiricus',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      routerConfig: AppRouter.router,
    );
  }
}
