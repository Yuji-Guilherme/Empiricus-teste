import 'package:empiricus_test/features/auth/domain/usecases/login_case.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empiricus_test/core/errors/failures.dart';

import '../../../../../mocks.dart';

void main() {
  late LoginUseCase useCase;
  late MockAuthRepository mockRepository;
  late MockAuthService mockService;

  setUp(() {
    mockRepository = MockAuthRepository();
    mockService = MockAuthService();
    useCase = LoginUseCase(
      repository: mockRepository,
      authService: mockService,
    );
  });

  const tEmail = 'test@email.com';
  const tPassword = '123';
  const tToken = 'fake_jwt_token';

  group('LoginUseCase', () {
    test(
      'Deve obter token do repositório e salvar no AuthService com sucesso',
      () async {
        when(
          () => mockRepository.login(tEmail, tPassword),
        ).thenAnswer((_) async => tToken);
        when(() => mockService.login(tToken)).thenAnswer((_) async {});

        await useCase(email: tEmail, password: tPassword);

        verify(() => mockRepository.login(tEmail, tPassword)).called(1);
        verify(() => mockService.login(tToken)).called(1);
      },
    );

    test('NÃO deve chamar AuthService se o Repositório falhar', () async {
      when(
        () => mockRepository.login(any(), any()),
      ).thenThrow(const AuthFailure());

      expect(
        () => useCase(email: tEmail, password: tPassword),
        throwsA(isA<AuthFailure>()),
      );

      verify(() => mockRepository.login(tEmail, tPassword)).called(1);
      verifyNever(() => mockService.login(any()));
    });
  });
}
