import 'package:empiricus_test/core/constants/mock_user.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements IAuthRepository {
  @override
  Future<String> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    if (email == MockUser.testEmail && password == MockUser.testPassword) {
      return 'mock_jwt_token_header_payload_signature';
    } else {
      throw AuthFailure();
    }
  }
}
