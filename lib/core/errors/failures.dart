import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable implements Exception {
  final String? message;

  const Failure([this.message]);

  @override
  List<Object?> get props => [message];
}

class AuthFailure extends Failure {
  const AuthFailure([super.message]);
}

class ServerFailure extends Failure {
  final int statusCode;

  const ServerFailure({required this.statusCode, String? message})
    : super(message);

  @override
  List<Object?> get props => [statusCode, message];
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
