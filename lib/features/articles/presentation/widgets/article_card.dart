import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:empiricus_test/core/components/network_image.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const .all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(8),
          border: .all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: .start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      article.name,
                      style: AppTypography.text.copyWith(fontWeight: .w500),
                      maxLines: 2,
                      overflow: .ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      article.shortDescription,
                      style: AppTypography.secondaryText,
                      maxLines: 4,
                      overflow: .ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Align(
                alignment: .center,
                child: Hero(
                  tag: article.slug,
                  child: ClipRRect(
                    borderRadius: .circular(4),
                    child: AppNetworkImage(
                      imageUrl: article.imageSmall,
                      width: 80,
                      height: 132,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
