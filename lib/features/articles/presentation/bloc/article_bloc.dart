import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'article_event.dart';
import 'article_state.dart';

class ArticleBloc extends Bloc<ArticleEvent, ArticleState> {
  final IArticleRepository _repository;

  ArticleBloc({required IArticleRepository repository})
    : _repository = repository,
      super(ArticleInitial()) {
    on<LoadArticles>(_onLoadArticles);
    on<RefreshArticles>(_onRefreshArticles);
  }

  Future<void> _onLoadArticles(
    LoadArticles event,
    Emitter<ArticleState> emit,
  ) async {
    emit(ArticleLoading());

    try {
      final articles = await _repository.getArticles();

      emit(ArticleLoaded(articles: articles));
    } on Failure catch (e) {
      emit(ArticleError(e));
    } catch (e) {
      emit(const ArticleError(UnknownFailure()));
    }
  }

  Future<void> _onRefreshArticles(
    RefreshArticles event,
    Emitter<ArticleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ArticleLoaded) return;

    try {
      emit(currentState.copyWith(refreshFailure: null));
      final articles = await _repository.getArticles();

      emit(ArticleLoaded(articles: articles));
    } on Failure catch (failure) {
      emit(currentState.copyWith(refreshFailure: failure));
    } catch (e) {
      emit(const ArticleError(UnknownFailure()));
    }
  }
}
