import '../repositories/article_repository.dart';

class ToggleBookmarkUseCase {
  final ArticleRepository repository;
  ToggleBookmarkUseCase(this.repository);

  Future<void> call(int articleId, bool isBookmarked) {
    return repository.toggleBookmark(articleId, isBookmarked);
  }
}
