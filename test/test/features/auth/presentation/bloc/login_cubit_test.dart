import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/utils/failure_extension.dart';
import 'package:empiricus_test/features/auth/domain/usecases/login_case.dart';
import 'package:empiricus_test/features/auth/presentation/bloc/login_cubit.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockLoginUseCase extends Mock implements LoginUseCase {}

void main() {
  late LoginCubit cubit;
  late MockLoginUseCase mockUseCase;

  setUp(() {
    mockUseCase = MockLoginUseCase();
    cubit = LoginCubit(loginUseCase: mockUseCase);
  });

  tearDown(() {
    cubit.close();
  });

  group('LoginCubit', () {
    test('O estado inicial deve ser LoginInitial', () {
      expect(cubit.state, LoginInitial());
    });

    const tEmail = 'teste@empiricus.com.br';
    const tPassword = '123';

    blocTest<LoginCubit, LoginState>(
      'Deve emitir [LoginLoading, LoginSuccess] quando o login for bem sucedido',
      build: () {
        when(
          () => mockUseCase(email: tEmail, password: tPassword),
        ).thenAnswer((_) async {});
        return cubit;
      },
      act: (cubit) => cubit.loginSubmitted(email: tEmail, password: tPassword),
      expect: () => [LoginLoading(), LoginSuccess()],
      verify: (_) {
        verify(() => mockUseCase(email: tEmail, password: tPassword)).called(1);
      },
    );

    blocTest<LoginCubit, LoginState>(
      'Deve emitir [LoginLoading, LoginFailure] com mensagem da extension quando ocorrer AuthFailure',
      build: () {
        when(
          () => mockUseCase(email: tEmail, password: tPassword),
        ).thenThrow(const AuthFailure());
        return cubit;
      },
      act: (cubit) => cubit.loginSubmitted(email: tEmail, password: tPassword),
      expect: () => [
        LoginLoading(),
        LoginFailure(const AuthFailure().displayMessage),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Deve emitir [LoginLoading, LoginFailure] com mensagem de conexão quando ocorrer NetworkFailure',
      build: () {
        when(
          () => mockUseCase(email: tEmail, password: tPassword),
        ).thenThrow(const NetworkFailure());
        return cubit;
      },
      act: (cubit) => cubit.loginSubmitted(email: tEmail, password: tPassword),
      expect: () => [
        LoginLoading(),
        LoginFailure(const NetworkFailure().displayMessage),
      ],
    );

    blocTest<LoginCubit, LoginState>(
      'Deve emitir [LoginLoading, LoginFailure] com mensagem erros não tratados',
      build: () {
        when(
          () => mockUseCase(email: tEmail, password: tPassword),
        ).thenThrow(Exception('Erro desconhecido'));
        return cubit;
      },
      act: (cubit) => cubit.loginSubmitted(email: tEmail, password: tPassword),
      expect: () => [
        LoginLoading(),
        LoginFailure(const UnknownFailure().displayMessage),
      ],
    );
  });
}
