import 'dart:async';

import 'package:equatable/equatable.dart';

sealed class ArticleEvent extends Equatable {
  const ArticleEvent();

  @override
  List<Object> get props => [];
}

class LoadArticles extends ArticleEvent {}

class RefreshArticles extends ArticleEvent {
  final Completer? completer;

  const RefreshArticles({this.completer});

  @override
  List<Object> get props => [if (completer != null) completer!];
}

class RetryArticles extends ArticleEvent {}
