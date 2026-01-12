import 'package:empiricus_test/core/components/error_button.dart';
import 'package:empiricus_test/core/components/error_icon_widget.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:flutter/material.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final IconData icon;
  final VoidCallback onRetry;
  final bool? isLoading;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
    required this.icon,
    this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const .all(24.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            ErrorIconWidget(icon: icon, size: 32),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: .center,
              style: AppTypography.text.copyWith(height: 1.5),
            ),
            const SizedBox(height: 16),
            ErrorButton(
              onPress: onRetry,
              icon: Icons.refresh,
              isLoading: isLoading,
              text: 'Tentar Novamente',
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
