import 'package:empiricus_test/features/articles/data/models/article_model.dart';
import 'package:equatable/equatable.dart';

sealed class ArticleState extends Equatable {
  const ArticleState();

  @override
  List<Object> get props => [];
}

final class ArticleInitial extends ArticleState {}

final class ArticleLoading extends ArticleState {}

final class ArticleLoaded extends ArticleState {
  final List<ArticleModel> articles;

  const ArticleLoaded({required this.articles});

  @override
  List<Object> get props => [articles];
}

final class ArticleError extends ArticleState {
  final String message;

  const ArticleError(this.message);

  @override
  List<Object> get props => [message];
}
