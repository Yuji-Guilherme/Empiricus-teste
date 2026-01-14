import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ArticleDetailEvent extends Equatable {
  const ArticleDetailEvent();
}

class LoadArticleDetail extends ArticleDetailEvent {
  final String slug;
  final ArticleEntity? article;

  const LoadArticleDetail(this.slug, {this.article});

  @override
  List<Object?> get props => [slug, article];
}

class RetryArticleDetail extends ArticleDetailEvent {
  final String slug;
  const RetryArticleDetail(this.slug);

  @override
  List<Object> get props => [slug];
}
