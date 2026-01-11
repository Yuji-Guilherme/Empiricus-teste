import 'package:empiricus_test/core/components/network_image.dart';
import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_state.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/author_widget.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/detail_not_found.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/detail_skeleton.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatelessWidget {
  final String slug;
  final ArticleModel? article;

  const DetailsPage({super.key, required this.slug, this.article});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = sl<ArticleDetailBloc>();
        if (article == null) bloc.add(LoadArticleDetail(slug));

        return bloc;
      },
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 0,
          backgroundColor: Colors.transparent,
          systemOverlayStyle: .dark,
          leading: Padding(
            padding: const .all(12),
            child: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: AppColors.contrast,
                size: 22,
              ),
              onPressed: () =>
                  context.canPop() ? context.pop() : context.go('/'),
            ),
          ),
        ),
        body: BlocBuilder<ArticleDetailBloc, ArticleDetailState>(
          builder: (context, state) {
            if (article != null) return _buildContent(article!);

            return switch (state) {
              ArticleDetailLoading() ||
              ArticleDetailInitial() => DetailSkeleton(),
              ArticleDetailError() => DetailNotFound(),
              ArticleDetailLoaded(:final article) => _buildContent(article),
            };
          },
        ),
      ),
    );
  }

  Widget _buildContent(ArticleModel article) {
    return SingleChildScrollView(
      padding: const .symmetric(horizontal: 20, vertical: 10),
      child: Column(
        crossAxisAlignment: .start,
        children: [
          Text(
            "ASSINATURA",
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 12,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(article.name, style: AppTypography.title),
          const SizedBox(height: 16),
          Hero(
            tag: article.identifier.slug,
            child: ClipRRect(
              borderRadius: .circular(8),
              child: AppNetworkImage(
                imageUrl: article.imageLarge,
                width: double.infinity,
                height: 190,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            article.description,
            textAlign: .justify,
            style: AppTypography.text,
          ),
          const SizedBox(height: 24),
          if (article.authors.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text("Escrito por:", style: AppTypography.subtitle),
            const SizedBox(height: 8),
            ...article.authors.map((author) => AuthorWidget(author: author)),
          ],
          if (article.features.isNotEmpty) ...[
            const SizedBox(height: 16),
            const Text("Destaques:", style: AppTypography.subtitle),
            const SizedBox(height: 16),
            ...article.features.map(
              (feature) => FeatureWidget(feature: feature),
            ),
          ],
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}
