import 'package:empiricus_test/core/components/network_image.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:empiricus_test/features/articles/data/models/author_model.dart';
import 'package:flutter/material.dart';

class AuthorWidget extends StatelessWidget {
  final AuthorModel author;

  const AuthorWidget({super.key, required this.author});

  @override
  Widget build(BuildContext context) {
    final hasDescription =
        author.description != null && author.description!.isNotEmpty;

    return Container(
      padding: const .symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: hasDescription ? .start : .center,
        children: [
          ClipOval(
            child: AppNetworkImage(
              imageUrl: author.photoSmallUrl ?? '',
              width: 50,
              height: 50,
              errorWidget: Container(
                color: AppColors.lightGrey,
                child: const Icon(
                  Icons.person,
                  color: AppColors.mediumGrey,
                  size: 28,
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: .start,
              mainAxisSize: .min,
              children: [
                Text(author.name, style: AppTypography.text),
                if (hasDescription) ...[
                  const SizedBox(height: 4),
                  Text(
                    author.description!,
                    style: AppTypography.secondaryText.copyWith(
                      fontStyle: .italic,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
