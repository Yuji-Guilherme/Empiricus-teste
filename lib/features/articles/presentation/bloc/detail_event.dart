import 'package:equatable/equatable.dart';

sealed class ArticleDetailEvent extends Equatable {
  const ArticleDetailEvent();
}

class LoadArticleDetail extends ArticleDetailEvent {
  final String slug;
  const LoadArticleDetail(this.slug);
  @override
  List<Object> get props => [slug];
}
