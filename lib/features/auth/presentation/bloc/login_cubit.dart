import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/utils/failure_extension.dart';
import 'package:empiricus_test/features/auth/domain/usecases/login_case.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

part 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final LoginUseCase _loginUseCase;

  LoginCubit({required LoginUseCase loginUseCase})
    : _loginUseCase = loginUseCase,
      super(LoginInitial());

  Future<void> loginSubmitted({
    required String email,
    required String password,
  }) async {
    emit(LoginLoading());

    try {
      await _loginUseCase(email: email, password: password);

      emit(LoginSuccess());
    } on Failure catch (failure) {
      emit(LoginFailure(failure.displayMessage));
    } catch (e) {
      emit(LoginFailure(const UnknownFailure().displayMessage));
    }
  }
}
