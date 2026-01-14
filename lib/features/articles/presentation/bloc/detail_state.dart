import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/domain/entities/article_entity.dart';
import 'package:equatable/equatable.dart';

sealed class ArticleDetailState extends Equatable {
  const ArticleDetailState();
  @override
  List<Object?> get props => [];
}

final class ArticleDetailInitial extends ArticleDetailState {}

final class ArticleDetailLoading extends ArticleDetailState {}

final class ArticleDetailLoaded extends ArticleDetailState {
  final ArticleEntity article;
  const ArticleDetailLoaded(this.article);

  @override
  List<Object> get props => [article];
}

final class ArticleDetailError extends ArticleDetailState {
  final Failure failure;
  final bool isRetrying;
  final Failure? retryFailure;

  const ArticleDetailError(
    this.failure, {
    this.isRetrying = false,
    this.retryFailure,
  });

  ArticleDetailError copyWith({
    Failure? failure,
    bool? isRetrying,
    Failure? retryFailure,
  }) {
    return ArticleDetailError(
      failure ?? this.failure,
      isRetrying: isRetrying ?? this.isRetrying,
      retryFailure: retryFailure,
    );
  }

  @override
  List<Object?> get props => [failure, isRetrying, retryFailure];
}

final class ArticleDetailNotfound extends ArticleDetailState {}
