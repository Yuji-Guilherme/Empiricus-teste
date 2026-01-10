import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final IAuthRepository _authRepository;
  final AuthService _authService;

  LoginCubit({
    required IAuthRepository authRepository,
    required AuthService authService,
  }) : _authRepository = authRepository,
       _authService = authService,
       super(LoginInitial());

  Future<void> loginSubmitted({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      final token = await _authRepository.login(email, password);
      await _authService.login(token);

      emit(LoginSuccess());
    } on Failure catch (e) {
      emit(LoginFailure(e.message));
    } catch (e) {
      emit(const LoginFailure('Ocorreu um erro inesperado. Tente novamente.'));
    }
  }
}
