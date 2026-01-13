import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/pages/details_page.dart';
import 'package:empiricus_test/features/articles/presentation/pages/home_page.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements IArticleRepository {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockArticleRepository mockRepo;
  late MockAuthService mockAuthService;

  final tArticle = ArticleEntity(
    slug: 'slug-detalhe',
    name: 'Artigo da Home',
    shortDescription: 'Clicar para ver detalhes',
    description: 'Conteúdo completo do artigo...',
    imageLarge: 'img.jpg',
    imageSmall: 'img.jpg',
    authors: [],
    features: [],
  );

  final tArticleDetail = tArticle;

  setUp(() {
    mockRepo = MockArticleRepository();
    mockAuthService = MockAuthService();

    sl.registerFactory(() => ArticleBloc(repository: sl()));
    sl.registerFactory(() => ArticleDetailBloc(repository: sl()));

    sl.registerFactory<IArticleRepository>(() => mockRepo);

    sl.registerSingleton<AuthService>(mockAuthService);
  });

  tearDown(() {
    sl.reset();
  });

  testWidgets(
    'Fluxo Home -> Detalhes: Clique no card deve navegar e carregar detalhes',
    (tester) async {
      when(() => mockAuthService.isLoggedIn).thenReturn(true);
      when(() => mockAuthService.addListener(any())).thenReturn(null);

      when(() => mockRepo.getArticles()).thenAnswer((_) async => [tArticle]);

      when(
        () => mockRepo.getArticleBySlug('slug-detalhe'),
      ).thenAnswer((_) async => tArticleDetail);

      final router = GoRouter(
        initialLocation: '/',
        routes: [
          GoRoute(path: '/', builder: (context, state) => const HomePage()),
          GoRoute(
            path: '/:slug',
            name: 'details',
            builder: (context, state) {
              final slug = state.pathParameters['slug']!;
              final article = state.extra as ArticleEntity?;
              return DetailsPage(slug: slug, article: article);
            },
          ),
        ],
      );

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));

      await tester.pump();

      expect(find.text('Artigo da Home'), findsOneWidget);

      await tester.tap(find.byType(ArticleCard));

      await tester.pump(const Duration(seconds: 1));
      await tester.pump();

      expect(find.byType(DetailsPage), findsOneWidget);
      expect(find.text('Conteúdo completo do artigo...'), findsOneWidget);
    },
  );
}
