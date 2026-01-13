import 'package:bloc_test/bloc_test.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_bloc.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockArticleRepository extends Mock implements IArticleRepository {}

void main() {
  late ArticleDetailBloc bloc;
  late MockArticleRepository mockRepository;

  const tSlug = 'slug-teste';

  const tArticle = ArticleEntity(
    slug: tSlug,
    name: 'Artigo Teste',
    shortDescription: 'Short',
    description: 'Long',
    imageLarge: 'img.jpg',
    imageSmall: 'img_s.jpg',
    authors: [],
    features: [],
  );

  final tServerFailure = ServerFailure(
    message: 'Erro interno',
    statusCode: 500,
  );
  final tNotFoundFailure = ServerFailure(
    message: 'Não encontrado',
    statusCode: 404,
  );

  setUp(() {
    mockRepository = MockArticleRepository();
    bloc = ArticleDetailBloc(repository: mockRepository);
  });

  tearDown(() {
    bloc.close();
  });

  group('ArticleDetailBloc', () {
    test('Estado inicial deve ser ArticleDetailInitial', () {
      expect(bloc.state, ArticleDetailInitial());
    });

    group('LoadArticleDetail', () {
      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve emitir [Loading, Loaded] quando o repositório retornar sucesso',
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenAnswer((_) async => tArticle);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadArticleDetail(tSlug)),
        expect: () => [
          ArticleDetailLoading(),
          const ArticleDetailLoaded(tArticle),
        ],
      );

      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve emitir [Loading, Notfound] quando o erro for 404',
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenThrow(tNotFoundFailure);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadArticleDetail(tSlug)),
        expect: () => [ArticleDetailLoading(), ArticleDetailNotfound()],
      );

      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve emitir [Loading, Error] quando for outro erro (ex: 500)',
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenThrow(tServerFailure);
          return bloc;
        },
        act: (bloc) => bloc.add(const LoadArticleDetail(tSlug)),
        expect: () => [
          ArticleDetailLoading(),
          ArticleDetailError(tServerFailure),
        ],
      );
    });

    group('RetryArticleDetail', () {
      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve emitir [Error(isRetrying: true), Loaded] ao recuperar com sucesso',
        seed: () => ArticleDetailError(tServerFailure),
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenAnswer((_) async => tArticle);
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryArticleDetail(tSlug)),
        expect: () => [
          ArticleDetailError(tServerFailure, isRetrying: true),
          const ArticleDetailLoaded(tArticle),
        ],
      );

      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve manter o erro original e setar retryFailure se o erro for o mesmo',
        seed: () => const ArticleDetailError(NetworkFailure()),
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenThrow(const NetworkFailure());
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryArticleDetail(tSlug)),
        expect: () => [
          const ArticleDetailError(NetworkFailure(), isRetrying: true),
          const ArticleDetailError(
            NetworkFailure(),
            isRetrying: false,
            retryFailure: NetworkFailure(),
          ),
        ],
      );

      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve mudar para Notfound se o erro mudar para 404 durante o retry',
        seed: () => const ArticleDetailError(NetworkFailure()),
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenThrow(ServerFailure(statusCode: 404));
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryArticleDetail(tSlug)),
        expect: () => [
          const ArticleDetailError(NetworkFailure(), isRetrying: true),
          ArticleDetailNotfound(),
        ],
      );

      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'Deve emitir [Error(isRetrying: true), Notfound] se retornar 404 no retry',
        seed: () => ArticleDetailError(tServerFailure),
        build: () {
          when(
            () => mockRepository.getArticleBySlug(tSlug),
          ).thenThrow(tNotFoundFailure);
          return bloc;
        },
        act: (bloc) => bloc.add(const RetryArticleDetail(tSlug)),
        expect: () => [
          ArticleDetailError(tServerFailure, isRetrying: true),
          ArticleDetailNotfound(),
        ],
      );

      blocTest<ArticleDetailBloc, ArticleDetailState>(
        'NÃO deve fazer nada se não estiver em estado de erro',
        seed: () => const ArticleDetailLoaded(tArticle),
        build: () => bloc,
        act: (bloc) => bloc.add(const RetryArticleDetail(tSlug)),
        expect: () => [],
        verify: (_) {
          verifyNever(() => mockRepository.getArticleBySlug(any()));
        },
      );
    });
  });

  test(
    'Deve emitir Loaded IMEDIATAMENTE sem chamar o repo se o evento tiver article',
    () {
      bloc.add(LoadArticleDetail(tSlug, article: tArticle));

      expectLater(bloc.stream, emits(ArticleDetailLoaded(tArticle)));

      verifyNever(() => mockRepository.getArticleBySlug(any()));
    },
  );
}
