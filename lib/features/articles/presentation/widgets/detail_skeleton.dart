import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class DetailSkeleton extends StatelessWidget {
  const DetailSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const .symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.offWhite,
            child: Container(
              width: 60,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(4),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.offWhite,
            child: Container(
              width: double.infinity,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(8),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.offWhite,
            child: Container(
              width: 250,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(8),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.offWhite,
            child: Container(
              width: double.infinity,
              height: 190,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(16),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ListView.separated(
            itemCount: 5,
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            separatorBuilder: (_, _) => const SizedBox(height: 10),
            itemBuilder: (_, _) => Shimmer.fromColors(
              baseColor: AppColors.lightGrey,
              highlightColor: AppColors.offWhite,
              child: Container(
                width: double.infinity,
                height: 20,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: .circular(4),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.offWhite,
            child: Container(
              width: 150,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(4),
              ),
            ),
          ),
          const SizedBox(height: 40),
          Shimmer.fromColors(
            baseColor: AppColors.lightGrey,
            highlightColor: AppColors.offWhite,
            child: Container(
              width: 120,
              height: 28,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: .circular(4),
              ),
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Shimmer.fromColors(
                baseColor: AppColors.lightGrey,
                highlightColor: AppColors.offWhite,
                child: CircleAvatar(backgroundColor: Colors.white, radius: 25),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Shimmer.fromColors(
                    baseColor: AppColors.lightGrey,
                    highlightColor: AppColors.offWhite,
                    child: Container(
                      width: 120,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: .circular(4),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: AppColors.lightGrey,
                    highlightColor: AppColors.offWhite,
                    child: Container(
                      width: 80,
                      height: 12,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: .circular(4),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
