import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/core/components/network_image.dart';
import 'package:flutter/material.dart';

class ArticleCard extends StatelessWidget {
  final ArticleModel article;
  final VoidCallback onTap;

  const ArticleCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: .circular(12),
      child: Container(
        padding: const .all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: .circular(12),
          border: .all(color: Colors.grey.shade200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: .center,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    article.name,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: .bold,
                      color: AppColors.text,
                    ),
                    maxLines: 2,
                    overflow: .ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    article.shortDescription,
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.darkGrey,
                      fontWeight: .bold,
                    ),
                    maxLines: 4,
                    overflow: .ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 24),
            ClipRRect(
              borderRadius: .circular(8),
              child: AppNetworkImage(
                imageUrl: article.imageSmall,
                width: 90,
                height: 132,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
