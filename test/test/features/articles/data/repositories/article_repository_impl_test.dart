import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/data/repositories/article_repository_impl.dart';

import '../../../../../mocks.dart';

void main() {
  late ArticleRepositoryImpl repository;
  late MockHttpAdapter mockHttpAdapter;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockHttpAdapter = MockHttpAdapter();
    mockNetworkInfo = MockNetworkInfo();
    repository = ArticleRepositoryImpl(
      client: mockHttpAdapter,
      networkInfo: mockNetworkInfo,
    );
  });

  final jsonName = 'Nome do Artigo';

  final tArticleJson = {
    "identifier": {"slug": "slug-teste"},
    "name": jsonName,
    "shortDescription": "Descricao Curta",
    "description": "Descricao Longa HTML...",
    "imageLarge": "https://img.com/large.jpg",
    "imageSmall": "https://img.com/small.jpg",
    "authors": [
      {"name": "Autor Teste"},
    ],
    "features": [],
  };

  final tResponseMap = {
    "groups": [tArticleJson],
  };

  group('ArticleRepository', () {
    test(
      'getArticles: Deve verificar a conexão de rede antes de chamar a API',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockHttpAdapter.get()).thenAnswer((_) async => tResponseMap);

        await repository.getArticles();

        verify(() => mockNetworkInfo.isConnected).called(1);
      },
    );

    test(
      'getArticles: Deve lançar NetworkFailure se não houver internet',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => false);

        expect(() => repository.getArticles(), throwsA(isA<NetworkFailure>()));
        verifyZeroInteractions(mockHttpAdapter);
      },
    );

    test(
      'getArticles: Deve retornar Lista de Artigos quando a API responder com sucesso',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockHttpAdapter.get()).thenAnswer((_) async => tResponseMap);

        final result = await repository.getArticles();

        expect(result, isA<List<ArticleEntity>>());
        expect(result.length, 1);
        expect(result.first.name, jsonName);
      },
    );

    test(
      'getArticles: Deve lançar DataParsingFailure se a resposta não for um Map',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockHttpAdapter.get()).thenAnswer((_) async => []);

        expect(
          () => repository.getArticles(),
          throwsA(isA<DataParsingFailure>()),
        );
      },
    );

    test(
      'getArticles: Deve lançar DataParsingFailure se o JSON vier incompleto',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);

        final tBadJson = {
          "groups": [
            {
              "identifier": {"slug": "slug-teste"},
            },
          ],
        };

        when(() => mockHttpAdapter.get()).thenAnswer((_) async => tBadJson);

        expect(() => repository.getArticles(), throwsA(isA<Failure>()));
      },
    );

    test(
      'getArticleBySlug: Deve retornar o artigo correto quando encontrar o slug',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockHttpAdapter.get()).thenAnswer((_) async => tResponseMap);

        final result = await repository.getArticleBySlug('slug-teste');

        expect(result.slug, 'slug-teste');
      },
    );

    test(
      'getArticleBySlug: Deve lançar ServerFailure(404) quando o slug não existir na lista',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(() => mockHttpAdapter.get()).thenAnswer((_) async => tResponseMap);

        expect(
          () => repository.getArticleBySlug('slug-inexistente'),
          throwsA(predicate((e) => e is ServerFailure && e.statusCode == 404)),
        );
      },
    );

    test(
      'Deve propagar ServerFailure quando a API falhar internamente',
      () async {
        when(() => mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        final tFailure = ServerFailure(
          statusCode: 500,
          message: 'Internal Error',
        );

        when(() => mockHttpAdapter.get()).thenThrow(tFailure);

        expect(
          () => repository.getArticleBySlug('slug-teste'),
          throwsA(tFailure),
        );
      },
    );
  });
}
