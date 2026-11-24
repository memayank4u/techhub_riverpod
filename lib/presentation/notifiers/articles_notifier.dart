import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/common/resource.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/usecases/get_articles_usecase.dart';
import '../../domain/usecases/get_bookmarks_usecase.dart';
import '../../domain/usecases/toggle_bookmark_usecase.dart';
import '../../core/di/providers.dart';
import 'articles_state.dart';

class ArticlesNotifier extends StateNotifier<ArticlesState> {
  final GetArticlesUseCase _getArticlesUseCase;
  final GetBookmarksUseCase _getBookmarksUseCase;
  final ToggleBookmarkUseCase _toggleBookmarkUseCase;
  StreamSubscription? _subscription;

  ArticlesNotifier({
    required GetArticlesUseCase getArticlesUseCase,
    required GetBookmarksUseCase getBookmarksUseCase,
    required ToggleBookmarkUseCase toggleBookmarkUseCase,
  })  : _getArticlesUseCase = getArticlesUseCase,
        _getBookmarksUseCase = getBookmarksUseCase,
        _toggleBookmarkUseCase = toggleBookmarkUseCase,
        super(const ArticlesState()) {
    loadArticles();
  }

  void loadArticles({bool forceRefresh = false}) {
    final bookmarks = _getBookmarksUseCase();
    state = state.copyWith(bookmarkedArticles: bookmarks);

    _subscription?.cancel();
    _subscription = _getArticlesUseCase(forceRefresh: forceRefresh).listen(
      (resource) {
        if (resource is ResourceLoading) {
          state = state.copyWith(
            isLoading: state.articles.isEmpty,
            isRefreshing: forceRefresh,
            articles: _enrich(resource.data ?? state.articles, bookmarks),
            errorMessage: null,
          );
        } else if (resource is ResourceSuccess) {
          state = state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isOffline: false,
            articles: _enrich(resource.data ?? [], bookmarks),
            errorMessage: null,
          );
        } else if (resource is ResourceError) {
          state = state.copyWith(
            isLoading: false,
            isRefreshing: false,
            isOffline: true,
            articles: _enrich(resource.data ?? state.articles, bookmarks),
            errorMessage: resource.message,
          );
        }
      },
    );
  }

  void selectTab(int index) {
    if (index == 1) {
      final bookmarks = _getBookmarksUseCase();
      state = state.copyWith(selectedTab: index, bookmarkedArticles: bookmarks);
    } else {
      state = state.copyWith(selectedTab: index);
    }
  }

  Future<void> toggleBookmark(ArticleEntity article) async {
    final newBookmarkedState = !article.isBookmarked;
    await _toggleBookmarkUseCase(article.id, newBookmarkedState);
    final bookmarks = _getBookmarksUseCase();
    state = state.copyWith(
      bookmarkedArticles: bookmarks,
      articles: _enrich(state.articles, bookmarks),
    );
  }

  List<ArticleEntity> _enrich(
    List<ArticleEntity> list,
    List<ArticleEntity> bookmarks,
  ) {
    final ids = bookmarks.map((b) => b.id).toSet();
    return list.map((a) => a.copyWith(isBookmarked: ids.contains(a.id))).toList();
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final articlesNotifierProvider =
    StateNotifierProvider<ArticlesNotifier, ArticlesState>((ref) {
  return ArticlesNotifier(
    getArticlesUseCase: ref.watch(getArticlesUseCaseProvider),
    getBookmarksUseCase: ref.watch(getBookmarksUseCaseProvider),
    toggleBookmarkUseCase: ref.watch(toggleBookmarkUseCaseProvider),
  );
});
