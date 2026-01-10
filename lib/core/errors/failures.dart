abstract class Failure implements Exception {
  final String message;
  Failure(this.message);
}

class AuthFailure extends Failure {
  AuthFailure() : super('E-mail ou senha incorretos.');
}

class ServerFailure extends Failure {
  final int statusCode;
  ServerFailure(super.message, this.statusCode);
}

class NetworkFailure extends Failure {
  NetworkFailure() : super('Sem conexão com a internet');
}
