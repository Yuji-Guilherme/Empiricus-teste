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
    on<RetryArticles>(_onRetryArticles);
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

    emit(currentState.copyWith(refreshFailure: null));
    try {
      final articles = await _repository.getArticles();

      emit(ArticleLoaded(articles: articles));
    } on Failure catch (failure) {
      emit(currentState.copyWith(refreshFailure: failure));
    } catch (e) {
      emit(currentState.copyWith(refreshFailure: const UnknownFailure()));
    } finally {
      event.completer?.complete();
    }
  }

  Future<void> _onRetryArticles(
    RetryArticles event,
    Emitter<ArticleState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ArticleError) return;

    emit(currentState.copyWith(isRetrying: true, retryFailure: null));
    try {
      final articles = await _repository.getArticles();

      emit(ArticleLoaded(articles: articles));
    } on Failure catch (failure) {
      if (currentState.failure != failure) return emit(ArticleError(failure));

      emit(currentState.copyWith(isRetrying: false, retryFailure: failure));
    } catch (e) {
      emit(
        currentState.copyWith(
          isRetrying: false,
          retryFailure: const UnknownFailure(),
        ),
      );
    }
  }
}
