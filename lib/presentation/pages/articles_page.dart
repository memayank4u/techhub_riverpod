import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../core/constants/app_strings.dart';
import '../../core/theme/app_dimensions.dart';
import '../../domain/entities/article_entity.dart';
import '../notifiers/articles_notifier.dart';
import '../widgets/empty_state_view.dart';
import '../widgets/loading_view.dart';
import '../widgets/offline_banner.dart';
import '../widgets/theme_selector_sheet.dart';

class ArticlesPage extends ConsumerWidget {
  const ArticlesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final state = ref.watch(articlesNotifierProvider);
    final notifier = ref.read(articlesNotifierProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          AppStrings.articlesTitle,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.palette_outlined),
            tooltip: AppStrings.themeSettingsTooltip,
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (_) => const ThemeSelectorSheet(),
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: AppStrings.commonRefresh,
            onPressed: () => notifier.loadArticles(forceRefresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          // Tab Selector (Latest vs Saved Bookmarks)
          Container(
            margin: const EdgeInsets.symmetric(
              horizontal: AppDimensions.spacingMedium,
              vertical: AppDimensions.spacingSmall,
            ),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: _buildTabButton(
                    context: context,
                    title: AppStrings.articlesTabAll,
                    isSelected: state.selectedTab == 0,
                    onTap: () => notifier.selectTab(0),
                  ),
                ),
                Expanded(
                  child: _buildTabButton(
                    context: context,
                    title: AppStrings.articlesTabSaved,
                    isSelected: state.selectedTab == 1,
                    badgeCount: state.bookmarkedArticles.length,
                    onTap: () => notifier.selectTab(1),
                  ),
                ),
              ],
            ),
          ),

          // Offline Banner
          OfflineBanner(
            visible: state.isOffline,
            message: state.errorMessage ?? AppStrings.commonOfflineBanner,
            onRetry: () => notifier.loadArticles(forceRefresh: true),
          ),

          // List content
          Expanded(
            child: _buildListContent(context, state, notifier),
          ),
        ],
      ),
    );
  }

  Widget _buildTabButton({
    required BuildContext context,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? theme.colorScheme.primary : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.onSurfaceVariant,
              ),
            ),
            if (badgeCount != null && badgeCount > 0) ...[
              const SizedBox(width: 6),
              CircleAvatar(
                radius: 9,
                backgroundColor: isSelected
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                child: Text(
                  '$badgeCount',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildListContent(
    BuildContext context,
    dynamic state,
    ArticlesNotifier notifier,
  ) {
    if (state.isLoading && state.displayList.isEmpty) {
      return const LoadingView();
    }
    if (state.displayList.isEmpty) {
      return EmptyStateView(
        title: state.selectedTab == 1
            ? AppStrings.articlesEmptyBookmarks
            : AppStrings.commonEmptyTitle,
        subtitle: state.selectedTab == 1
            ? AppStrings.articlesEmptyBookmarksSub
            : AppStrings.commonEmptySubtitle,
        onAction: state.selectedTab == 0
            ? () => notifier.loadArticles(forceRefresh: true)
            : null,
      );
    }

    return RefreshIndicator(
      onRefresh: () async => notifier.loadArticles(forceRefresh: true),
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.spacingMedium,
          vertical: AppDimensions.spacingSmall,
        ),
        itemCount: state.displayList.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (context, index) {
          final article = state.displayList[index];
          return _buildArticleCard(context, article, notifier);
        },
      ),
    );
  }

  Widget _buildArticleCard(
    BuildContext context,
    ArticleEntity article,
    ArticlesNotifier notifier,
  ) {
    final theme = Theme.of(context);

    return Card(
      clipBehavior: Clip.antiAlias,
      elevation: 1,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        onTap: () async {
          final uri = Uri.tryParse(article.webUrl);
          if (uri != null && await canLaunchUrl(uri)) {
            await launchUrl(uri, mode: LaunchMode.externalApplication);
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (article.coverImageUrl != null && article.coverImageUrl!.isNotEmpty)
              Image.network(
                article.coverImageUrl!,
                height: 160,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const SizedBox.shrink(),
              ),
            Padding(
              padding: const EdgeInsets.all(AppDimensions.spacingMedium),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 14,
                        backgroundImage: article.authorProfileImageUrl != null
                            ? NetworkImage(article.authorProfileImageUrl!)
                            : null,
                        child: article.authorProfileImageUrl == null
                            ? const Icon(Icons.person, size: 14)
                            : null,
                      ),
                      const SizedBox(width: AppDimensions.spacingSmall),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              article.authorName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              article.publishedDate,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.onSurfaceVariant,
                                fontSize: 10,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          article.isBookmarked
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: article.isBookmarked
                              ? theme.colorScheme.primary
                              : null,
                        ),
                        onPressed: () => notifier.toggleBookmark(article),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Text(
                    article.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      height: 1.3,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    article.description,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.4,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppDimensions.spacingSmall),
                  Row(
                    children: [
                      if (article.tags.isNotEmpty)
                        Expanded(
                          child: Wrap(
                            spacing: 6,
                            children: article.tags.take(3).map((tag) {
                              return Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: theme.colorScheme.surfaceContainerHighest,
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(
                                  '#$tag',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: theme.colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      Row(
                        children: [
                          const Icon(Icons.access_time, size: 14),
                          const SizedBox(width: 4),
                          Text(
                            '${article.readingTimeMinutes} min read',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
