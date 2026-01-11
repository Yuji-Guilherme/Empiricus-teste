import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ErrorIconWidget extends StatelessWidget {
  final IconData icon;
  final double size;

  const ErrorIconWidget({super.key, required this.icon, this.size = 64});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: .1),
        shape: .circle,
      ),
      child: Icon(icon, size: size, color: AppColors.primary),
    );
  }
}
