import 'package:hive/hive.dart';
import '../../core/database/hive_service.dart';
import '../models/article_model.dart';

abstract class ArticleLocalDataSource {
  List<ArticleModel> getCachedArticles();
  Future<void> cacheArticles(List<ArticleModel> articles);
  Set<int> getBookmarkedIds();
  Future<void> updateBookmark(int articleId, bool isBookmarked);
}

class ArticleLocalDataSourceImpl implements ArticleLocalDataSource {
  static const String keyArticles = 'cached_articles_list';
  static const String keyBookmarks = 'bookmarked_ids_set';

  @override
  Set<int> getBookmarkedIds() {
    try {
      final box = Hive.box(HiveService.bookmarksBox);
      final rawList = box.get(keyBookmarks, defaultValue: <dynamic>[]);
      if (rawList is List) {
        return rawList.map((e) => (e as num).toInt()).toSet();
      }
    } catch (_) {}
    return <int>{};
  }

  @override
  Future<void> updateBookmark(int articleId, bool isBookmarked) async {
    final box = Hive.box(HiveService.bookmarksBox);
    final currentSet = getBookmarkedIds();
    if (isBookmarked) {
      currentSet.add(articleId);
    } else {
      currentSet.remove(articleId);
    }
    await box.put(keyBookmarks, currentSet.toList());
  }

  @override
  List<ArticleModel> getCachedArticles() {
    try {
      final box = Hive.box(HiveService.articlesBox);
      final rawList = box.get(keyArticles);
      final bookmarkedIds = getBookmarkedIds();
      if (rawList is List) {
        return rawList.map((item) {
          final map = Map<String, dynamic>.from(item);
          final id = map['id'] ?? 0;
          return ArticleModel.fromJson(map, isBookmarked: bookmarkedIds.contains(id));
        }).toList();
      }
    } catch (_) {}
    return [];
  }

  @override
  Future<void> cacheArticles(List<ArticleModel> articles) async {
    final box = Hive.box(HiveService.articlesBox);
    final mapList = articles.map((a) => a.toMap()).toList();
    await box.put(keyArticles, mapList);
  }
}
