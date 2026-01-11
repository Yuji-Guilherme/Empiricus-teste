abstract class Failure implements Exception {
  final String? message;

  const Failure([this.message]);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

class ServerFailure extends Failure {
  final int statusCode;

  const ServerFailure({required this.statusCode, String? message})
    : super(message);
}

class DataParsingFailure extends Failure {
  const DataParsingFailure([super.message]);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message]);
}

class UnknownFailure extends Failure {
  const UnknownFailure([super.message]);
}
