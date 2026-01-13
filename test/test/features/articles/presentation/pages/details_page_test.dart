import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_test/core/di/service_locator.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/utils/failure_extension.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_state.dart';
import 'package:empiricus_test/features/articles/presentation/pages/details_page.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/detail_not_found.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/detail_skeleton.dart';
import 'package:empiricus_test/features/articles/presentation/widgets/error_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleDetailBloc
    extends MockBloc<ArticleDetailEvent, ArticleDetailState>
    implements ArticleDetailBloc {}

void main() {
  late MockArticleDetailBloc mockBloc;

  const tSlug = 'slug-teste';
  final tArticle = ArticleEntity(
    slug: tSlug,
    name: 'Artigo Detalhado',
    shortDescription: 'Short',
    description: 'Long description content...',
    imageLarge: 'img.jpg',
    imageSmall: 'img.jpg',
    authors: [],
    features: [],
  );

  setUpAll(() {
    registerFallbackValue(const LoadArticleDetail('fallback-slug'));
  });

  setUp(() {
    mockBloc = MockArticleDetailBloc();

    sl.registerFactory<ArticleDetailBloc>(() => mockBloc);
  });

  tearDown(() {
    sl.reset();
  });

  Future<void> loadDetailsPage(
    WidgetTester tester, {
    String slug = tSlug,
    ArticleEntity? article,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: DetailsPage(slug: slug, article: article),
      ),
    );
  }

  group('DetailsPage UI Integration', () {
    testWidgets(
      'Deve disparar LoadArticleDetail e mostrar Skeleton quando article for null',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ArticleDetailLoading());

        await loadDetailsPage(tester, slug: tSlug, article: null);

        await tester.pump(const Duration(milliseconds: 100));

        expect(find.byType(DetailSkeleton), findsOneWidget);

        verify(() => mockBloc.add(const LoadArticleDetail(tSlug))).called(1);
      },
    );

    testWidgets(
      'Deve exibir conteúdo do artigo quando estado mudar para Loaded',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ArticleDetailLoaded(tArticle));

        await loadDetailsPage(tester, article: null);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump();

        expect(find.text('Artigo Detalhado'), findsOneWidget);
        expect(find.text('Long description content...'), findsOneWidget);
        expect(find.byType(DetailSkeleton), findsNothing);
      },
    );

    testWidgets(
      'Deve exibir conteúdo IMEDIATAMENTE e NÃO disparar Load se article for passado',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ArticleDetailInitial());

        await loadDetailsPage(tester, slug: tSlug, article: tArticle);
        await tester.pump();

        expect(find.text('Artigo Detalhado'), findsOneWidget);

        verifyNever(() => mockBloc.add(any()));
      },
    );

    testWidgets(
      'Deve exibir widget DetailNotFound quando estado for Notfound',
      (tester) async {
        when(() => mockBloc.state).thenReturn(ArticleDetailNotfound());

        await loadDetailsPage(tester);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump();

        expect(find.byType(DetailNotFound), findsOneWidget);
        expect(find.byType(DetailSkeleton), findsNothing);
      },
    );

    testWidgets(
      'Deve exibir ErrorView e disparar RetryArticleDetail ao clicar no botão',
      (tester) async {
        when(
          () => mockBloc.state,
        ).thenReturn(const ArticleDetailError(ServerFailure(statusCode: 500)));

        await loadDetailsPage(tester);
        await tester.pump(const Duration(seconds: 1));
        await tester.pump();

        expect(find.byType(ErrorView), findsOneWidget);

        await tester.tap(find.text('Tentar Novamente'));

        verify(() => mockBloc.add(const RetryArticleDetail(tSlug))).called(1);
      },
    );

    testWidgets('Deve exibir SnackBar se falhar durante a tentativa de retry', (
      tester,
    ) async {
      final initialError = const ArticleDetailError(
        ServerFailure(statusCode: 500),
      );

      whenListen(
        mockBloc,
        Stream.fromIterable([
          initialError,
          initialError.copyWith(retryFailure: const NetworkFailure()),
        ]),
        initialState: initialError,
      );

      await loadDetailsPage(tester);
      await tester.pump(); // Processa stream
      await tester.pump(); // Processa SnackBar

      expect(find.text(NetworkFailure().displayMessage), findsOneWidget);
      expect(find.byType(ErrorView), findsOneWidget);
    });
  });
}
