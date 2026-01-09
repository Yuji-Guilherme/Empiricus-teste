import 'dart:convert';
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
      final response = await _client.get(uri);

      return _handleResponse(response);
    } catch (e) {
      throw Exception('Erro de conexão: $e');
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode == 200) {
      if (response.body.isEmpty) return null;
      return jsonDecode(response.body);
    } else {
      throw Exception('Erro na requisição: Código ${response.statusCode}');
    }
  }
}
