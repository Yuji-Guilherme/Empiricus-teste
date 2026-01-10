abstract class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class AuthFailure extends Failure {
  AuthFailure() : super('E-mail ou senha incorretos.');
}
