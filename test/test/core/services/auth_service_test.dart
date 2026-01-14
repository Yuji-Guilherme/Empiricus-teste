import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empiricus_test/core/services/auth_service.dart';

import '../../../mocks.dart';

void main() {
  late AuthService service;
  late MockFlutterSecureStorage mockStorage;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = AuthService(storage: mockStorage);
  });

  group('AuthService', () {
    test(
      'login deve salvar token, mudar isLoggedIn para true e notificar listeners',
      () async {
        const tToken = 'token_abc';
        when(
          () => mockStorage.write(key: 'auth_token', value: tToken),
        ).thenAnswer((_) async {});

        bool notified = false;
        service.addListener(() {
          notified = true;
        });

        await service.login(tToken);

        verify(
          () => mockStorage.write(key: 'auth_token', value: tToken),
        ).called(1);
        expect(service.isLoggedIn, true);
        expect(notified, true);
      },
    );

    test('checkLoginStatus deve recuperar estado corretamente', () async {
      when(
        () => mockStorage.read(key: 'auth_token'),
      ).thenAnswer((_) async => 'token_existente');

      await service.checkLoginStatus();

      expect(service.isLoggedIn, true);
    });

    test('logout deve limpar token e notificar', () async {
      when(
        () => mockStorage.delete(key: 'auth_token'),
      ).thenAnswer((_) async {});

      await service.logout();

      verify(() => mockStorage.delete(key: 'auth_token')).called(1);
      expect(service.isLoggedIn, false);
    });
  });
}
