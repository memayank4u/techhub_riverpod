import '../../core/common/resource.dart';
import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/article_repository.dart';
import '../datasources/article_local_datasource.dart';
import '../datasources/article_remote_datasource.dart';

class ArticleRepositoryImpl implements ArticleRepository {
  final ArticleRemoteDataSource remoteDataSource;
  final ArticleLocalDataSource localDataSource;

  ArticleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Stream<Resource<List<ArticleEntity>>> getArticles({bool forceRefresh = false}) async* {
    final cached = localDataSource.getCachedArticles();
    yield ResourceLoading(data: cached);

    final shouldFetch = cached.isEmpty || forceRefresh;

    if (shouldFetch) {
      try {
        final remoteModels = await remoteDataSource.fetchArticles();
        await localDataSource.cacheArticles(remoteModels);

        final updated = localDataSource.getCachedArticles();
        yield ResourceSuccess(updated);
      } catch (e) {
        yield ResourceError(
          'Could not reach Dev.to. Showing cached articles.',
          data: cached,
        );
      }
    } else {
      yield ResourceSuccess(cached);
    }
  }

  @override
  List<ArticleEntity> getBookmarkedArticles() {
    final all = localDataSource.getCachedArticles();
    return all.where((a) => a.isBookmarked).toList();
  }

  @override
  Future<void> toggleBookmark(int articleId, bool isBookmarked) async {
    await localDataSource.updateBookmark(articleId, isBookmarked);
  }
}
