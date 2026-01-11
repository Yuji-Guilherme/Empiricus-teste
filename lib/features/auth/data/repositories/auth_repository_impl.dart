import 'package:empiricus_test/core/constants/mock_user.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/network/network_info.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  final NetworkInfo _networkInfo;

  AuthRepositoryImpl({required NetworkInfo networkInfo})
    : _networkInfo = networkInfo;

  @override
  Future<String> login(String email, String password) async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkFailure();
    }

    await Future.delayed(const Duration(seconds: 1));

    if (email == MockUser.testEmail && password == MockUser.testPassword) {
      return 'mock_jwt_token_header_payload_signature';
    } else {
      throw const AuthFailure();
    }
  }
}
