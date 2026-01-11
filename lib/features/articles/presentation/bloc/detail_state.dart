import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:equatable/equatable.dart';

sealed class ArticleDetailState extends Equatable {
  const ArticleDetailState();
  @override
  List<Object> get props => [];
}

final class ArticleDetailInitial extends ArticleDetailState {}

final class ArticleDetailLoading extends ArticleDetailState {}

final class ArticleDetailLoaded extends ArticleDetailState {
  final ArticleModel article;
  const ArticleDetailLoaded(this.article);
  @override
  List<Object> get props => [article];
}

final class ArticleDetailError extends ArticleDetailState {
  final String message;
  const ArticleDetailError(this.message);
  @override
  List<Object> get props => [message];
}
