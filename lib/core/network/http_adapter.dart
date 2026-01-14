import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:http/http.dart' as http;

abstract class IHttpAdapter {
  Future<dynamic> get();
}

class HttpAdapterImpl implements IHttpAdapter {
  final http.Client _client;
  final String _baseUrl;

  HttpAdapterImpl({http.Client? client, required String baseUrl})
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
      throw const NetworkFailure();
    } on TimeoutException {
      throw const NetworkFailure();
    } catch (e) {
      if (e is Failure) rethrow;

      throw const UnknownFailure();
    }
  }

  dynamic _handleResponse(http.Response response) {
    if (response.statusCode < 200 || response.statusCode > 299) {
      throw ServerFailure(statusCode: response.statusCode);
    }

    if (response.body.isEmpty) return null;

    try {
      return jsonDecode(response.body);
    } catch (e) {
      throw const DataParsingFailure();
    }
  }
}
