import 'package:empiricus_test/features/articles/data/models/article_model.dart';

abstract class IArticleRepository {
  Future<List<ArticleModel>> getArticles();
  Future<ArticleModel> getArticleBySlug(String slug);
}
