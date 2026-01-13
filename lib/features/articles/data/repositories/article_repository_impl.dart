import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/core/network/http_service.dart';
import 'package:empiricus_test/core/network/network_info.dart';
import 'package:empiricus_test/features/articles/data/models/article_response_model.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';

class ArticleRepositoryImpl implements IArticleRepository {
  final IHttpAdapter _client;
  final NetworkInfo _networkInfo;

  ArticleRepositoryImpl({
    required IHttpAdapter client,
    required NetworkInfo networkInfo,
  }) : _client = client,
       _networkInfo = networkInfo;

  @override
  Future<List<ArticleEntity>> getArticles() async {
    if (!await _networkInfo.isConnected) {
      throw const NetworkFailure();
    }

    try {
      final response = await _client.get();

      if (response is! Map<String, dynamic>) {
        throw const DataParsingFailure();
      }

      final responseModel = ArticleResponseModel.fromJson(response);

      return responseModel.groups;
    } catch (e) {
      if (e is Failure) rethrow;
      throw const UnknownFailure();
    }
  }

  @override
  Future<ArticleEntity> getArticleBySlug(String slug) async {
    try {
      final response = await getArticles();

      return response.firstWhere(
        (article) => article.slug == slug,
        orElse: () => throw const ServerFailure(statusCode: 404),
      );
    } catch (e) {
      if (e is Failure) rethrow;
      throw const UnknownFailure();
    }
  }
}
