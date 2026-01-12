import 'package:empiricus_test/core/components/app_bar.dart';
import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/core/theme/app_colors.dart';
import 'package:empiricus_test/core/utils/app_alert.dart';
import 'package:empiricus_test/core/utils/failure_extension.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_state.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card_skeleton.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<ArticleBloc>()..add(LoadArticles()),
      child: Scaffold(
        appBar: CustomAppBar(
          title: const Text('Assinaturas'),
          actionWidget: IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              sl<AuthService>().logout();
            },
          ),
        ),
        body: BlocConsumer<ArticleBloc, ArticleState>(
          listener: (context, state) {
            if (state is ArticleLoaded && state.refreshFailure != null) {
              AppAlert.show(
                context,
                state.refreshFailure!.displayMessage,
                type: .error,
              );
            }
          },
          builder: (context, state) {
            return switch (state) {
              ArticleLoading() => _buildLoadingList(),
              ArticleError(:final failure) => ErrorView(
                message: failure.displayMessage,
                icon: failure.icon,
                onRetry: () {
                  context.read<ArticleBloc>().add(LoadArticles());
                },
              ),
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

  Widget _buildArticleList(BuildContext context, List<ArticleModel> articles) {
    if (articles.isEmpty) {
      return ErrorView(
        message: 'Ops! Sem artigos no momento.',
        icon: Icons.search_off_rounded,
        onRetry: () {
          context.read<ArticleBloc>().add(LoadArticles());
        },
      );
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

          return ArticleCard(
            article: article,
            onTap: () {
              context.pushNamed(
                'details',
                pathParameters: {'slug': article.identifier.slug},
                extra: article,
              );
            },
          );
        },
      ),
    );
  }
}
