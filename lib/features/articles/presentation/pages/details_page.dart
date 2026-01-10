import 'package:empiricus_test/core/components/network_image.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/theme/app_typography.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/author_widget.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/feature_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

class DetailsPage extends StatefulWidget {
  final String slug;
  final ArticleModel? article;

  const DetailsPage({super.key, required this.slug, this.article});

  @override
  State<DetailsPage> createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  late ArticleModel? _article;
  bool _isLoading = false;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _article = widget.article;

    if (_article == null) _fetchArticleBySlug();
  }

  Future<void> _fetchArticleBySlug() async {
    setState(() => _isLoading = true);

    if (mounted) {
      setState(() {
        _isLoading = false;
        _hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: CircularProgressIndicator(color: AppColors.contrast),
        ),
      );
    }

    if (_article == null && _hasError) {
      return Scaffold(
        appBar: AppBar(),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.broken_image,
                size: 64,
                color: AppColors.mediumGrey,
              ),
              const Text("Artigo não encontrado", style: AppTypography.text),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: () => context.go('/'),
                child: const Text("Ir para Início"),
              ),
            ],
          ),
        ),
      );
    }

    final article = _article!;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0,
        backgroundColor: Colors.transparent,
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),
      body: SingleChildScrollView(
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
      ),
    );
  }
}
