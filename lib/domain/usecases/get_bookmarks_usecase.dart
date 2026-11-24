import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';

class GetBookmarksUseCase {
  final ArticleRepository repository;
  GetBookmarksUseCase(this.repository);

  List<ArticleEntity> call() {
    return repository.getBookmarkedArticles();
  }
}
