import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:techhub_riverpod/core/common/resource.dart';
import 'package:techhub_riverpod/domain/entities/article_entity.dart';
import 'package:techhub_riverpod/domain/usecases/get_articles_usecase.dart';
import 'package:techhub_riverpod/domain/usecases/get_bookmarks_usecase.dart';
import 'package:techhub_riverpod/domain/usecases/toggle_bookmark_usecase.dart';
import 'package:techhub_riverpod/presentation/notifiers/articles_notifier.dart';

class MockGetArticlesUseCase extends Mock implements GetArticlesUseCase {}
class MockGetBookmarksUseCase extends Mock implements GetBookmarksUseCase {}
class MockToggleBookmarkUseCase extends Mock implements ToggleBookmarkUseCase {}

void main() {
  late MockGetArticlesUseCase mockGetArticlesUseCase;
  late MockGetBookmarksUseCase mockGetBookmarksUseCase;
  late MockToggleBookmarkUseCase mockToggleBookmarkUseCase;

  const sampleArticle = ArticleEntity(
    id: 101,
    title: 'Clean Architecture in Flutter',
    description: 'A deep dive into Clean Architecture with Riverpod.',
    webUrl: 'https://dev.to/example',
    coverImageUrl: 'https://example.com/cover.png',
    publishedDate: '2026-11-24',
    readingTimeMinutes: 5,
    tags: ['flutter', 'riverpod'],
    authorName: 'Mayank Patel',
    authorProfileImageUrl: 'https://example.com/user.png',
    isBookmarked: false,
  );

  setUp(() {
    mockGetArticlesUseCase = MockGetArticlesUseCase();
    mockGetBookmarksUseCase = MockGetBookmarksUseCase();
    mockToggleBookmarkUseCase = MockToggleBookmarkUseCase();

    when(() => mockGetBookmarksUseCase()).thenReturn(<ArticleEntity>[]);
    when(() => mockGetArticlesUseCase(forceRefresh: any(named: 'forceRefresh'))).thenAnswer(
      (_) => const Stream.empty(),
    );
  });

  test('ArticlesNotifier initial state has empty articles and isLoading false', () {
    final notifier = ArticlesNotifier(
      getArticlesUseCase: mockGetArticlesUseCase,
      getBookmarksUseCase: mockGetBookmarksUseCase,
      toggleBookmarkUseCase: mockToggleBookmarkUseCase,
    );
    expect(notifier.state.articles, isEmpty);
    expect(notifier.state.isLoading, isFalse);
  });

  test('ArticlesNotifier loads articles successfully from stream', () async {
    when(() => mockGetArticlesUseCase(forceRefresh: false)).thenAnswer(
      (_) => Stream.fromIterable([
        const ResourceLoading<List<ArticleEntity>>(),
        const ResourceSuccess<List<ArticleEntity>>([sampleArticle]),
      ]),
    );

    final notifier = ArticlesNotifier(
      getArticlesUseCase: mockGetArticlesUseCase,
      getBookmarksUseCase: mockGetBookmarksUseCase,
      toggleBookmarkUseCase: mockToggleBookmarkUseCase,
    );

    notifier.loadArticles(forceRefresh: false);
    await pumpEventQueue();

    expect(notifier.state.articles.length, equals(1));
    expect(notifier.state.articles.first.id, equals(101));
    expect(notifier.state.isLoading, isFalse);
    expect(notifier.state.isOffline, isFalse);
  });
}
