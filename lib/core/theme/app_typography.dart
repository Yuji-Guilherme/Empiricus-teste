import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class AppTypography {
  static const TextStyle title = TextStyle(
    fontSize: 28,
    fontWeight: .w800,
    height: 1.2,
  );
  static const TextStyle subtitle = TextStyle(fontSize: 20, fontWeight: .w500);
  static const TextStyle text = TextStyle(fontSize: 16);
  static const TextStyle secondaryText = TextStyle(
    fontSize: 14,
    color: AppColors.darkGrey,
  );
}
