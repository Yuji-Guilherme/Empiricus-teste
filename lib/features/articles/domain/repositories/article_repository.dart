import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';

abstract class IArticleRepository {
  Future<List<ArticleEntity>> getArticles();
  Future<ArticleEntity> getArticleBySlug(String slug);
}
