import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/data/models/feature_model.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/article_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements IArticleRepository {}

void main() {
  late ArticleBloc bloc;
  late MockArticleRepository mockRepository;

  const tArticle = ArticleEntity(
    slug: 'slug-teste',
    name: 'Artigo Teste',
    shortDescription: 'Short Desc',
    description: 'Full Desc',
    imageLarge: 'img_l.jpg',
    imageSmall: 'img_s.jpg',
    authors: [],
    features: [FeatureModel(title: 'Feature', description: 'Desc')],
  );

  final tArticlesList = [tArticle];
  final tFailure = ServerFailure(statusCode: 500, message: 'Erro Server');

  setUp(() {
    mockRepository = MockArticleRepository();
    bloc = ArticleBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ArticleBloc', () {
    test('Estado inicial deve ser ArticleInitial', () {
      expect(bloc.state, ArticleInitial());
    });

    blocTest<ArticleBloc, ArticleState>(
      'LoadArticles: Deve emitir [Loading, Loaded] com dados quando sucesso',
      build: () {
        when(
          () => mockRepository.getArticles(),
        ).thenAnswer((_) async => tArticlesList);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadArticles()),
      expect: () => [ArticleLoading(), ArticleLoaded(articles: tArticlesList)],
      verify: (_) => verify(() => mockRepository.getArticles()).called(1),
    );

    blocTest<ArticleBloc, ArticleState>(
      'LoadArticles: Deve emitir [Loading, Error] quando ocorrer falha',
      build: () {
        when(() => mockRepository.getArticles()).thenThrow(tFailure);
        return bloc;
      },
      act: (bloc) => bloc.add(LoadArticles()),
      expect: () => [ArticleLoading(), ArticleError(tFailure)],
    );

    blocTest<ArticleBloc, ArticleState>(
      'RefreshArticles: Deve atualizar a lista e limpar erros anteriores',
      seed: () =>
          ArticleLoaded(articles: tArticlesList, refreshFailure: tFailure),
      build: () {
        when(() => mockRepository.getArticles()).thenAnswer((_) async => []);
        return bloc;
      },
      act: (bloc) => bloc.add(RefreshArticles()),
      expect: () => [
        ArticleLoaded(articles: tArticlesList, refreshFailure: null),
        const ArticleLoaded(articles: []),
      ],
    );

    blocTest<ArticleBloc, ArticleState>(
      'RefreshArticles: Deve MANTER a lista antiga e emitir refreshFailure se falhar',
      seed: () => ArticleLoaded(articles: tArticlesList),
      build: () {
        when(
          () => mockRepository.getArticles(),
        ).thenThrow(const NetworkFailure());
        return bloc;
      },
      act: (bloc) => bloc.add(RefreshArticles()),
      expect: () => [
        ArticleLoaded(
          articles: tArticlesList,
          refreshFailure: const NetworkFailure(),
        ),
      ],
    );

    blocTest<ArticleBloc, ArticleState>(
      'RefreshArticles: NÃO deve fazer nada se o estado não for Loaded',
      seed: () => ArticleError(tFailure),
      build: () => bloc,
      act: (bloc) => bloc.add(RefreshArticles()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockRepository.getArticles());
      },
    );
  });

  group('ReloadArticles (Tentativa de Recuperação na Tela de Erro)', () {
    blocTest<ArticleBloc, ArticleState>(
      'Deve emitir [Error(isRetrying: true), Loaded] quando a recuperação funcionar',
      seed: () => ArticleError(tFailure),
      build: () {
        when(
          () => mockRepository.getArticles(),
        ).thenAnswer((_) async => tArticlesList);
        return bloc;
      },
      act: (bloc) => bloc.add(RetryArticles()),
      expect: () => [
        ArticleError(tFailure, isRetrying: true, retryFailure: null),
        ArticleLoaded(articles: tArticlesList),
      ],
    );

    blocTest<ArticleBloc, ArticleState>(
      'Deve emitir [Error(isRetrying: true), Error(retryFailure: failure)] quando falhar novamente',
      seed: () => ArticleError(tFailure),
      build: () {
        when(
          () => mockRepository.getArticles(),
        ).thenThrow(const NetworkFailure());
        return bloc;
      },
      act: (bloc) => bloc.add(RetryArticles()),
      expect: () => [
        ArticleError(tFailure, isRetrying: true, retryFailure: null),

        ArticleError(
          tFailure,
          isRetrying: false,
          retryFailure: const NetworkFailure(),
        ),
      ],
    );

    blocTest<ArticleBloc, ArticleState>(
      'NÃO deve fazer nada se o estado atual não for ArticleError',
      seed: () => ArticleLoaded(articles: tArticlesList),
      build: () => bloc,
      act: (bloc) => bloc.add(RetryArticles()),
      expect: () => [],
      verify: (_) {
        verifyNever(() => mockRepository.getArticles());
      },
    );
  });
}
