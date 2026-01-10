import 'package:cached_network_image/cached_network_image.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = .cover,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (context, url) => Shimmer.fromColors(
        baseColor: AppColors.lightGrey,
        highlightColor: AppColors.offWhite,
        child: Container(width: width, height: height, color: Colors.white),
      ),
      errorWidget: (context, url, error) => Container(
        width: width,
        height: height,
        color: AppColors.lightGrey,
        child: const Icon(Icons.broken_image, color: AppColors.mediumGrey),
      ),
      fadeInDuration: const Duration(milliseconds: 200),
    );
  }
}
