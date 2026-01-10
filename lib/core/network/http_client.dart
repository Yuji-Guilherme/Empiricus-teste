import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:http/http.dart' as http;

abstract class IHttpClient {
  Future<dynamic> get();
}

class HttpClientImplementation implements IHttpClient {
  final http.Client _client;
  final String _baseUrl;

  HttpClientImplementation({http.Client? client, required String baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl;

  @override
  Future<dynamic> get() async {
    final uri = Uri.parse(_baseUrl);

    try {
      final response = await _client
          .get(uri)
          .timeout(const Duration(seconds: 10));

      return _handleResponse(response);
    } on SocketException {
      throw NetworkFailure();
    } on TimeoutException {
      throw NetworkFailure();
    } catch (e) {
      if (e is Failure) rethrow;

      throw ServerFailure("Erro inesperado", 500);
    }
  }

  dynamic _handleResponse(http.Response response) {
    switch (response.statusCode) {
      case 200:
        if (response.body.isEmpty) return null;
        try {
          return jsonDecode(response.body);
        } catch (e) {
          throw ServerFailure(
            "Erro ao processar resposta do servidor",
            response.statusCode,
          );
        }
      case 404:
        throw ServerFailure("Recurso não encontrado", 404);
      case >= 500:
        throw ServerFailure(
          "Serviço indisponível no momento",
          response.statusCode,
        );
      default:
        throw ServerFailure(
          'Erro inesperado: ${response.reasonPhrase ?? "Desconhecido"}',
          response.statusCode,
        );
    }
  }
}
