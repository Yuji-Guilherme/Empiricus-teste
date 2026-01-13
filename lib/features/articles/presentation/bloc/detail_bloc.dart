import 'package:empiricus_test/core/errors/failures.dart';
import 'package:empiricus_test/features/articles/domain/repositories/article_repository.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_event.dart';
import 'package:empiricus_test/features/articles/presentation/bloc/detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ArticleDetailBloc extends Bloc<ArticleDetailEvent, ArticleDetailState> {
  final IArticleRepository _repository;

  ArticleDetailBloc({required IArticleRepository repository})
    : _repository = repository,
      super(ArticleDetailInitial()) {
    on<LoadArticleDetail>(_onLoadArticleDetail);
    on<RetryArticleDetail>(_onRetryArticleDetail);
  }

  Future<void> _onLoadArticleDetail(
    LoadArticleDetail event,
    Emitter<ArticleDetailState> emit,
  ) async {
    emit(ArticleDetailLoading());
    try {
      final article = await _repository.getArticleBySlug(event.slug);

      emit(ArticleDetailLoaded(article));
    } on Failure catch (failure) {
      if (failure case ServerFailure(statusCode: 404)) {
        emit(ArticleDetailNotfound());
      } else {
        emit(ArticleDetailError(failure));
      }
    } catch (e) {
      emit(const ArticleDetailError(UnknownFailure()));
    }
  }

  Future<void> _onRetryArticleDetail(
    RetryArticleDetail event,
    Emitter<ArticleDetailState> emit,
  ) async {
    final currentState = state;
    if (currentState is! ArticleDetailError) return;

    emit(currentState.copyWith(isRetrying: true, retryFailure: null));
    try {
      final article = await _repository.getArticleBySlug(event.slug);

      emit(ArticleDetailLoaded(article));
    } on Failure catch (failure) {
      if (failure case ServerFailure(statusCode: 404)) {
        return emit(ArticleDetailNotfound());
      }

      if (currentState.failure != failure) {
        return emit(ArticleDetailError(failure));
      }

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
