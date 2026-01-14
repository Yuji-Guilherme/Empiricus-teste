import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';

class LoginUseCase {
  final IAuthRepository _repository;
  final AuthService _authService;

  LoginUseCase({
    required IAuthRepository repository,
    required AuthService authService,
  }) : _repository = repository,
       _authService = authService;

  Future<void> call({required String email, required String password}) async {
    final token = await _repository.login(email, password);

    await _authService.login(token);
  }
}
