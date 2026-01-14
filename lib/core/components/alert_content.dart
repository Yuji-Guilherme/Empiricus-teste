import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AlertContent extends StatelessWidget {
  final String message;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback? onClose;

  const AlertContent({
    super.key,
    required this.message,
    required this.backgroundColor,
    required this.icon,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const .symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: .circular(4),
      ),
      child: Row(
        children: [
          Icon(icon, color: AppColors.background, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(
                fontWeight: .w500,
                color: AppColors.background,
                fontSize: 14,
              ),
            ),
          ),
          if (onClose != null)
            GestureDetector(
              onTap: onClose,
              child: const Padding(
                padding: .only(left: 8.0),
                child: Icon(Icons.close, color: AppColors.background, size: 18),
              ),
            ),
        ],
      ),
    );
  }
}
