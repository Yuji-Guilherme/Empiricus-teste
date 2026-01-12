import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/features/auth/presentation/bloc/login_cubit.dart';
import 'package:empiricus_test/features/auth/presentation/pages/login_page.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/email_input.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/login_button.dart';
import 'package:empiricus_test/features/auth/presentation/widgets/password_input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginCubit extends MockCubit<LoginState> implements LoginCubit {}

void main() {
  late MockLoginCubit mockCubit;

  setUp(() {
    mockCubit = MockLoginCubit();

    sl.registerFactory<LoginCubit>(() => mockCubit);
  });

  tearDown(() {
    sl.reset();
  });

  Future<void> loadLoginPage(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPage()));
  }

  group('LoginPage UI Integration', () {
    testWidgets('Deve renderizar os componentes iniciais corretamente', (
      tester,
    ) async {
      when(() => mockCubit.state).thenReturn(LoginInitial());

      await loadLoginPage(tester);

      expect(find.text('Acesse sua conta'), findsOneWidget);
      expect(find.byType(EmailInput), findsOneWidget);
      expect(find.byType(PasswordInput), findsOneWidget);
      expect(find.byType(LoginButton), findsOneWidget);
      expect(find.text('Entrar'), findsOneWidget);
    });

    testWidgets(
      'Deve mostrar erro no EmailInput quando perder o foco com valor inválido',
      (tester) async {
        when(() => mockCubit.state).thenReturn(LoginInitial());
        await loadLoginPage(tester);

        final emailFinder = find.byType(TextFormField).first;
        await tester.enterText(emailFinder, 'email-invalido');

        final passwordFinder = find.byType(TextFormField).last;
        await tester.tap(passwordFinder);
        await tester.pump();

        expect(find.text('E-mail inválido'), findsOneWidget);
      },
    );

    testWidgets(
      'Deve mostrar CircularProgressIndicator no botão quando estado for LoginLoading',
      (tester) async {
        when(() => mockCubit.state).thenReturn(LoginLoading());

        await loadLoginPage(tester);

        expect(find.text('Entrar'), findsNothing);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        final button = tester.widget<FilledButton>(find.byType(FilledButton));
        expect(button.onPressed, isNull);
      },
    );

    testWidgets('Deve exibir SnackBar de erro quando estado for LoginFailure', (
      tester,
    ) async {
      whenListen(
        mockCubit,
        Stream.fromIterable([
          LoginLoading(),
          const LoginFailure('Credenciais inválidas'),
        ]),
        initialState: LoginInitial(),
      );

      await loadLoginPage(tester);

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Credenciais inválidas'), findsOneWidget);
      expect(find.byType(SnackBar), findsOneWidget);
    });

    testWidgets(
      'Deve habilitar o botão e chamar o cubit quando o formulário for válido',
      (tester) async {
        when(() => mockCubit.state).thenReturn(LoginInitial());
        when(
          () => mockCubit.loginSubmitted(
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenAnswer((_) async {});

        await loadLoginPage(tester);

        await tester.enterText(find.byType(EmailInput), 'teste@empiricus.com');
        await tester.enterText(find.byType(PasswordInput), '123456');
        await tester.pump();

        await tester.tap(find.byType(LoginButton));

        verify(
          () => mockCubit.loginSubmitted(
            email: 'teste@empiricus.com',
            password: '123456',
          ),
        ).called(1);
      },
    );
  });
}
