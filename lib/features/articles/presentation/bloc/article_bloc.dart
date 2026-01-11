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
      emit(ArticleError(e.message));
    } catch (e) {
      emit(
        const ArticleError(
          "Ocorreu um erro inesperado ao carregar as assinaturas.",
        ),
      );
    }
  }

  Future<void> _onRefreshArticles(
    RefreshArticles event,
    Emitter<ArticleState> emit,
  ) async {
    try {
      final articles = await _repository.getArticles();
      emit(ArticleLoaded(articles: articles));
    } on Failure catch (e) {
      emit(ArticleError(e.message));
    } catch (e) {
      emit(const ArticleError("Erro ao atualizar."));
    }
  }
}
