import '../entities/article_entity.dart';
import '../../core/common/resource.dart';

abstract class ArticleRepository {
  Stream<Resource<List<ArticleEntity>>> getArticles({bool forceRefresh = false});
  List<ArticleEntity> getBookmarkedArticles();
  Future<void> toggleBookmark(int articleId, bool isBookmarked);
}
