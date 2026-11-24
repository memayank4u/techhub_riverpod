import '../entities/article_entity.dart';
import '../repositories/article_repository.dart';
import '../../core/common/resource.dart';

class GetArticlesUseCase {
  final ArticleRepository repository;
  GetArticlesUseCase(this.repository);

  Stream<Resource<List<ArticleEntity>>> call({bool forceRefresh = false}) {
    return repository.getArticles(forceRefresh: forceRefresh);
  }
}
