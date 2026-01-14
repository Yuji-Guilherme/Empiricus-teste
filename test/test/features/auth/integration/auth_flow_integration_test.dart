import 'package:empiricus_test/core/constants/mock_user.dart';
import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/network/network_info.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/core/utils/failure_extension.dart';
import 'package:empiricus_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:empiricus_test/features/auth/domain/usecases/login_case.dart';
import 'package:empiricus_test/features/auth/presentation/bloc/login_cubit.dart';
import 'package:empiricus_test/features/auth/presentation/pages/login_page.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/login_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockNetworkInfo extends Mock implements NetworkInfo {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockNetworkInfo mockNetworkInfo;
  late MockSecureStorage mockStorage;
  late AuthService authService;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    mockStorage = MockSecureStorage();

    sl.registerFactory<NetworkInfo>(() => mockNetworkInfo);
    sl.registerFactory<FlutterSecureStorage>(() => mockStorage);

    authService = AuthService(storage: sl());
    sl.registerSingleton<AuthService>(authService);

    sl.registerFactory<IAuthRepository>(
      () => AuthRepositoryImpl(networkInfo: sl()),
    );
    sl.registerFactory<LoginUseCase>(
      () => LoginUseCase(repository: sl(), authService: sl()),
    );
    sl.registerFactory<LoginCubit>(() => LoginCubit(loginUseCase: sl()));
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets(
    'Fluxo via Observer: Login deve disparar refreshListenable e redirecionar para Home',
    (tester) async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
      when(
        () => mockStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async {});

      final router = GoRouter(
        initialLocation: '/login',
        refreshListenable: authService,
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const LoginPage(),
          ),
          GoRoute(
            path: '/',
            name: 'home',
            redirect: (context, state) {
              final isLoggedIn = sl<AuthService>().isLoggedIn;
              if (!isLoggedIn) return '/login';
              return null;
            },
            builder: (context, state) =>
                const Scaffold(body: Text('Home Screen')),
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.enterText(
        find.byType(TextFormField).first,
        MockUser.testEmail,
      );
      await tester.enterText(
        find.byType(TextFormField).last,
        MockUser.testPassword,
      );
      await tester.pump();

      await tester.tap(find.byType(LoginButton));

      await tester.pumpAndSettle();

      expect(find.text('Home Screen'), findsOneWidget);

      verify(
        () => mockStorage.write(
          key: 'auth_token',
          value: any(named: 'value'),
        ),
      ).called(1);
    },
  );

  testWidgets('Falha de Rede deve exibir SnackBar e não navegar', (
    tester,
  ) async {
    when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

    await tester.pumpWidget(MaterialApp(home: const LoginPage()));

    await tester.enterText(find.byType(TextFormField).first, 'a@a.com');
    await tester.enterText(find.byType(TextFormField).last, '123456');
    await tester.pump();

    await tester.tap(find.byType(LoginButton));
    await tester.pump(); // Processa a lógica
    await tester.pump(); // Processa a exibição do SnackBar

    expect(find.text(NetworkFailure().displayMessage), findsOneWidget);

    expect(find.byType(LoginButton), findsOneWidget);

    verifyNever(
      () => mockStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    );
  });
}
