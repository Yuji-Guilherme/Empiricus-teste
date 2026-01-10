import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/features/articles/bloc/article_bloc.dart';
import 'package:empiricus_test/features/articles/bloc/article_event.dart';
import 'package:empiricus_test/features/articles/bloc/article_state.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card_skeleton.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticleBloc>()..add(LoadArticles()),
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: 68,
          leading: Padding(
            padding: const .only(left: 5),
            child: Container(
              padding: const .all(12),
              child: SvgPicture.asset('assets/images/logo.svg', fit: .contain),
            ),
          ),
          title: const Text('Assinaturas'),
          centerTitle: true,
          actions: [
            Padding(
              padding: const .only(right: 4),
              child: IconButton(
                icon: const Icon(Icons.logout),
                onPressed: () {
                  sl<AuthService>().logout();
                },
              ),
            ),
          ],
        ),
        body: BlocBuilder<ArticleBloc, ArticleState>(
          builder: (context, state) {
            return switch (state) {
              ArticleLoading() => _buildLoadingList(),
              ArticleError(:final message) => _buildError(context, message),
              ArticleLoaded(:final articles) => _buildArticleList(
                context,
                articles,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),
      ),
    );
  }

  Widget _buildLoadingList() {
    return ListView.separated(
      padding: const .all(16),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 16),
      itemBuilder: (_, _) => const ArticleCardSkeleton(),
    );
  }

  Widget _buildError(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: const .all(24.0),
        child: Column(
          mainAxisAlignment: .center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.grey),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: .center,
              style: const TextStyle(color: AppColors.text, fontWeight: .bold),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: () {
                context.read<ArticleBloc>().add(LoadArticles());
              },
              child: const Text('Tentar Novamente'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildArticleList(BuildContext context, List<ArticleModel> articles) {
    if (articles.isEmpty) {
      return const Center(child: Text('Nenhum artigo encontrado.'));
    }

    return RefreshIndicator(
      color: AppColors.contrast,
      onRefresh: () async {
        final bloc = context.read<ArticleBloc>();
        bloc.add(RefreshArticles());
        await bloc.stream.firstWhere((s) => s is! ArticleLoading);
      },
      child: ListView.separated(
        padding: const .all(16),
        itemCount: articles.length,
        separatorBuilder: (_, _) => const SizedBox(height: 16),
        itemBuilder: (_, index) {
          final article = articles[index];

          return ArticleCard(article: article, onTap: () {});
        },
      ),
    );
  }
}
