import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/services/auth_service.dart';
import 'package:empiricus_test/core/utils/failure_extension.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_state.dart';
import 'package:empiricus_test/features/articles/presentation/pages/home_page.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/article_card_skeleton.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleBloc extends MockBloc<ArticleEvent, ArticleState>
    implements ArticleBloc {}

class MockAuthService extends Mock implements AuthService {}

void main() {
  late MockArticleBloc mockBloc;
  late MockAuthService mockAuthService;

  final tArticle = ArticleEntity(
    slug: 'slug-1',
    name: 'Artigo Teste',
    shortDescription: 'Descricao curta',
    description: 'Full',
    imageLarge: 'img_l.jpg',
    imageSmall: 'img_s.jpg',
    authors: [],
    features: [],
  );
  final tArticles = [tArticle];

  setUp(() async {
    mockBloc = MockArticleBloc();
    mockAuthService = MockAuthService();

    sl.registerFactory<ArticleBloc>(() => mockBloc);
    sl.registerFactory<AuthService>(() => mockAuthService);
  });

  tearDown(() async {
    sl.reset();
  });

  Future<void> loadHomePage(WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomePage()));
  }

  group('HomePage UI Integration', () {
    testWidgets('Deve exibir ArticleCardSkeleton quando estado for Loading', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ArticleLoading());

      await loadHomePage(tester);

      // Assert
      expect(find.byType(ArticleCardSkeleton), findsWidgets);
      expect(find.byType(ArticleCard), findsNothing);
    });

    testWidgets('Deve exibir lista de Artigos quando estado for Loaded', (
      tester,
    ) async {
      // Arrange
      when(() => mockBloc.state).thenReturn(ArticleLoaded(articles: tArticles));

      // Act
      await loadHomePage(tester);

      // Assert
      expect(find.byType(ArticleCard), findsOneWidget);
      expect(find.text('Artigo Teste'), findsOneWidget);
      expect(find.text('Descricao curta'), findsOneWidget);
    });

    testWidgets(
      'Deve exibir ErrorView customizada quando a lista estiver vazia',
      (tester) async {
        when(
          () => mockBloc.state,
        ).thenReturn(const ArticleLoaded(articles: []));

        await loadHomePage(tester);

        expect(find.text('Ops! Sem artigos no momento.'), findsOneWidget);
        expect(find.byType(ErrorView), findsOneWidget);
      },
    );

    testWidgets(
      'Deve exibir ErrorView e disparar RetryArticles ao clicar no botão',
      (tester) async {
        when(
          () => mockBloc.state,
        ).thenReturn(ArticleError(const ServerFailure(statusCode: 500)));

        await loadHomePage(tester);

        // Assert Visual
        expect(find.byType(ErrorView), findsOneWidget);

        await tester.tap(find.text('Tentar Novamente'));

        verify(() => mockBloc.add(RetryArticles())).called(1);
      },
    );

    testWidgets(
      'Deve exibir SnackBar de erro e MANTER a lista visível no refresh falho',
      (tester) async {
        whenListen(
          mockBloc,
          Stream.fromIterable([
            ArticleLoaded(articles: tArticles),
            ArticleLoaded(
              articles: tArticles,
              refreshFailure: const NetworkFailure(),
            ),
          ]),
          initialState: ArticleLoaded(articles: tArticles),
        );

        await loadHomePage(tester);
        await tester.pump(); // Processa stream
        await tester.pump(); // Processa animação do SnackBar

        expect(find.text(NetworkFailure().displayMessage), findsOneWidget);

        expect(find.byType(ArticleCard), findsOneWidget);
        expect(find.byType(ErrorView), findsNothing);
      },
    );

    testWidgets('Deve chamar AuthService.logout ao clicar no ícone de sair', (
      tester,
    ) async {
      when(() => mockBloc.state).thenReturn(ArticleLoaded(articles: tArticles));
      when(() => mockAuthService.logout()).thenAnswer((_) async {});

      await loadHomePage(tester);

      await tester.tap(find.byIcon(Icons.logout));

      verify(() => mockAuthService.logout()).called(1);
    });
  });
}
