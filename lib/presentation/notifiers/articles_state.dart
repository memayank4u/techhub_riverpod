import 'package:equatable/equatable.dart';
import '../../../domain/entities/article_entity.dart';

class ArticlesState extends Equatable {
  final List<ArticleEntity> articles;
  final List<ArticleEntity> bookmarkedArticles;
  final int selectedTab; // 0 = Latest, 1 = Bookmarks
  final bool isLoading;
  final bool isRefreshing;
  final bool isOffline;
  final String? errorMessage;

  const ArticlesState({
    this.articles = const [],
    this.bookmarkedArticles = const [],
    this.selectedTab = 0,
    this.isLoading = false,
    this.isRefreshing = false,
    this.isOffline = false,
    this.errorMessage,
  });

  List<ArticleEntity> get displayList =>
      selectedTab == 0 ? articles : bookmarkedArticles;

  ArticlesState copyWith({
    List<ArticleEntity>? articles,
    List<ArticleEntity>? bookmarkedArticles,
    int? selectedTab,
    bool? isLoading,
    bool? isRefreshing,
    bool? isOffline,
    String? errorMessage,
  }) {
    return ArticlesState(
      articles: articles ?? this.articles,
      bookmarkedArticles: bookmarkedArticles ?? this.bookmarkedArticles,
      selectedTab: selectedTab ?? this.selectedTab,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isOffline: isOffline ?? this.isOffline,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        articles,
        bookmarkedArticles,
        selectedTab,
        isLoading,
        isRefreshing,
        isOffline,
        errorMessage,
      ];
}
