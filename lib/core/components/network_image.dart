import 'package:cached_network_image/cached_network_image.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AppNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? errorWidget;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = .cover,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      placeholder: (_, _) => Shimmer.fromColors(
        baseColor: AppColors.lightGrey,
        highlightColor: AppColors.offWhite,
        child: Container(width: width, height: height, color: Colors.white),
      ),
      errorWidget: (_, _, _) =>
          errorWidget != null ? errorWidget! : _buildDefaultError(),
      fadeInDuration: const Duration(milliseconds: 200),
    );
  }

  Widget _buildDefaultError() {
    return Container(
      width: width,
      height: height,
      color: AppColors.lightGrey,
      child: const Icon(Icons.broken_image, color: AppColors.mediumGrey),
    );
  }
}
