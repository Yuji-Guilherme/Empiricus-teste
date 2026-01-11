import 'package:empiricus_test/core/components/alert_content.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

enum AlertType { success, error, info, warning }

class AppAlert {
  AppAlert._();

  static void show(
    BuildContext context,
    String message, {
    AlertType type = AlertType.info,
  }) {
    final (Color color, IconData icon) = _getStyle(type);

    ScaffoldMessenger.of(context).clearSnackBars();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: AlertContent(
          message: message,
          backgroundColor: color,
          icon: icon,
          onClose: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        padding: const .all(16),
      ),
    );
  }

  static (Color, IconData) _getStyle(AlertType type) {
    return switch (type) {
      .success => (const Color(0xFF388E3C), Icons.check_circle_outline),
      .error => (AppColors.error, Icons.error_outline),
      .warning => (const Color(0xFFEF6C00), Icons.warning_amber_rounded),
      .info => (AppColors.darkGrey, Icons.info_outline),
    };
  }
}
