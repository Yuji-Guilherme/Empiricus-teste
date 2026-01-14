import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:empiricus_test/core/constants/mock_user.dart';

import '../../../../../mocks.dart';

void main() {
  late AuthRepositoryImpl repository;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockNetworkInfo = MockNetworkInfo();
    repository = AuthRepositoryImpl(networkInfo: mockNetworkInfo);
  });

  group('AuthRepository', () {
    test('Deve lançar NetworkFailure quando não houver conexão', () async {
      when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

      final call = repository.login;

      expect(
        () => call('email@teste.com', '123'),
        throwsA(isA<NetworkFailure>()),
      );
    });

    test(
      'Deve retornar um token quando as credenciais forem válidas',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        final result = await repository.login(
          MockUser.testEmail,
          MockUser.testPassword,
        );

        expect(result, isA<String>());
        expect(result.isNotEmpty, true);
      },
    );

    test(
      'Deve lançar AuthFailure quando e-mail ou senha estiverem errados',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        final call = repository.login;

        expect(
          () => call('errado@email.com', 'senhaerrada'),
          throwsA(isA<AuthFailure>()),
        );
      },
    );
  });
}
