import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/network/http_adapter.dart';

class MockClient extends Mock implements http.Client {}

void main() {
  late HttpAdapterImpl httpClient;
  late MockClient mockClient;
  const tBaseUrl = 'https://api.teste.com';

  setUp(() {
    mockClient = MockClient();
    httpClient = HttpAdapterImpl(client: mockClient, baseUrl: tBaseUrl);

    registerFallbackValue(Uri.parse(tBaseUrl));
  });

  group('HttpClientImplementation', () {
    test('Deve retornar dados decodificados quando o status for 200', () async {
      const tJson = {'key': 'value'};
      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response(jsonEncode(tJson), 200));

      final result = await httpClient.get();

      expect(result, tJson);
    });

    test('Deve lançar ServerFailure quando o status não for 200-299', () async {
      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      expect(() => httpClient.get(), throwsA(isA<ServerFailure>()));
    });

    test('Deve lançar NetworkFailure quando ocorrer SocketException', () async {
      when(
        () => mockClient.get(any()),
      ).thenThrow(const SocketException('Sem conexão'));

      expect(() => httpClient.get(), throwsA(isA<NetworkFailure>()));
    });

    test(
      'Deve lançar NetworkFailure quando ocorrer TimeoutException',
      () async {
        when(
          () => mockClient.get(any()),
        ).thenThrow(TimeoutException('Tempo esgotado'));

        expect(() => httpClient.get(), throwsA(isA<NetworkFailure>()));
      },
    );

    test('Deve lançar DataParsingFailure quando o JSON for inválido', () async {
      when(
        () => mockClient.get(any()),
      ).thenAnswer((_) async => http.Response('{json: quebrado', 200));

      expect(() => httpClient.get(), throwsA(isA<DataParsingFailure>()));
    });
  });
}
