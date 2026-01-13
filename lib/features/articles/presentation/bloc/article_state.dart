import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object?> get props => [];
}

final class ArticleInitial extends ArticleState {}

final class ArticleLoading extends ArticleState {}

final class ArticleLoaded extends ArticleState {
  final List<ArticleEntity> articles;
  final Failure? refreshFailure;

  const ArticleLoaded({required this.articles, this.refreshFailure});

  ArticleLoaded copyWith({
    List<ArticleEntity>? articles,
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
  final bool isRetrying;
  final Failure? retryFailure;

  const ArticleError(
    this.failure, {
    this.isRetrying = false,
    this.retryFailure,
  });

  ArticleError copyWith({
    Failure? failure,
    bool? isRetrying,
    Failure? retryFailure,
  }) {
    return ArticleError(
      failure ?? this.failure,
      isRetrying: isRetrying ?? this.isRetrying,
      retryFailure: retryFailure,
    );
  }

  @override
  List<Object?> get props => [failure, isRetrying, retryFailure];
}
