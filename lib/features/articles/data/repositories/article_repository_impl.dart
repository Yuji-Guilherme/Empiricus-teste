import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/network/http_client.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:empiricus_test/features/articles/data/models/article_response_model.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements IArticleRepository {
  final IHttpClient _client;

  ArticleRepositoryImpl(this._client);

  @override
  Future<List<ArticleModel>> getArticles() async {
    try {
      final response = await _client.get();

      if (response is! Map<String, dynamic>) {
        throw ServerFailure("Formato de resposta inválido", 0);
      }
      final responseModel = ArticleResponseModel.fromJson(response);

      return responseModel.groups;
    } catch (e) {
      throw ServerFailure("Erro ao processar os dados", 0);
    }
  }

  @override
  Future<ArticleModel> getArticleBySlug(String slug) async {
    try {
      final response = await getArticles();

      return response.firstWhere(
        (article) => article.identifier.slug == slug,
        orElse: () => throw ServerFailure("Artigo não encontrado", 404),
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw ServerFailure("Erro ao buscar", 0);
    }
  }
}
