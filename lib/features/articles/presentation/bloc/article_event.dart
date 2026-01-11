import 'package:equatable/equatable.dart';

sealed class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class LoadArticles extends ArticleEvent {}

class RefreshArticles extends ArticleEvent {}
