import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:empiricus_test/core/utils/app_alert.dart';
import 'package:empiricus_test/features/articles/data/models/feature_model.dart';
import 'package:flutter/material.dart';

class FeatureWidget extends StatelessWidget {
  final FeatureModel feature;

  const FeatureWidget({super.key, required this.feature});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        AppAlert.show(context, 'O destaque "${feature.title}" é informativo.');
      },
      child: Container(
        margin: const .only(bottom: 12),
        padding: const .all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(6),
          border: .all(color: AppColors.lightGrey, width: 0.8),
        ),
        child: Column(
          crossAxisAlignment: .start,
          children: [
            Row(
              children: [
                const Icon(
                  Icons.check_circle_outline,
                  color: AppColors.primary,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    feature.title,
                    style: const TextStyle(
                      fontWeight: .bold,
                      fontSize: 15,
                      color: AppColors.text,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              feature.description,
              style: AppTypography.secondaryText.copyWith(height: 1.4),
            ),
          ],
        ),
      ),
    );
  }
}
