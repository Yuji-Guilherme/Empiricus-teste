import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class ArticleCardSkeleton extends StatelessWidget {
  const ArticleCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: AppColors.lightGrey,
      highlightColor: AppColors.offWhite,
      child: Container(
        height: 156,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(8),
          border: .all(color: AppColors.mediumGrey),
        ),
      ),
    );
  }
}
