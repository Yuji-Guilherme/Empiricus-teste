import 'package:empiricus_test/core/errors/failures.dart';
import 'package:flutter/material.dart';

extension FailureExtension on Failure {
  String get displayMessage {
    return switch (this) {
      AuthFailure() => 'E-mail ou senha incorretos.',
      NetworkFailure() => 'Sem conexão. Verifique sua internet.',
      ServerFailure(statusCode: final code) => switch (code) {
        404 => 'Conteúdo não encontrado',
        500 => 'Serviço indisponível no momento',
        _ => 'Erro no servidor. Tente mais tarde.',
      },
      DataParsingFailure() =>
        'Erro ao processar as informações. Atualize o app ou tente novamente.',
      UnknownFailure() =>
        'Ocorreu um erro inesperado. Tente novamente mais tarde.',
      Failure(message: final msg) when msg != null && msg.isNotEmpty => msg,
      _ => 'Ocorreu um erro inesperado.',
    };
  }

  IconData get icon {
    return switch (this) {
      NetworkFailure() => Icons.wifi_off_rounded,
      ServerFailure(statusCode: 404) => Icons.search_off_rounded,
      _ => Icons.error_outline_rounded,
    };
  }
}
