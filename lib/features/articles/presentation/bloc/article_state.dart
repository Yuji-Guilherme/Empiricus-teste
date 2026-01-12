import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:equatable/equatable.dart';

sealed class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object?> get props => [];
}

final class ArticleInitial extends ArticleState {}

final class ArticleLoading extends ArticleState {}

final class ArticleLoaded extends ArticleState {
  final List<ArticleModel> articles;
  final Failure? refreshFailure;

  const ArticleLoaded({required this.articles, this.refreshFailure});

  ArticleLoaded copyWith({
    List<ArticleModel>? articles,
    Failure? refreshFailure,
  }) {
    return ArticleLoaded(
      articles: articles ?? this.articles,
      refreshFailure: refreshFailure,
    );
  }

  @override
  List<Object?> get props => [articles, refreshFailure];
}

final class ArticleError extends ArticleState {
  final Failure failure;

  const ArticleError(this.failure);

  @override
  List<Object> get props => [failure];
}
