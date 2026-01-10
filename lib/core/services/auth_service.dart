import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService extends ChangeNotifier {
  final FlutterSecureStorage _storage;
  static const _tokenKey = 'auth_token';

  bool _isLoggedIn = false;
  bool get isLoggedIn => _isLoggedIn;

  AuthService({required FlutterSecureStorage storage}) : _storage = storage;

  Future<void> checkLoginStatus() async {
    final token = await _storage.read(key: _tokenKey);
    _isLoggedIn = token != null && token.isNotEmpty;
    notifyListeners();
  }

  Future<void> login(String token) async {
    await _storage.write(key: _tokenKey, value: token);
    _isLoggedIn = true;
    notifyListeners();
  }

  Future<void> logout() async {
    await _storage.delete(key: _tokenKey);
    _isLoggedIn = false;
    notifyListeners();
  }
}
