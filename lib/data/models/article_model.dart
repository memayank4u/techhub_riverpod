import '../../domain/entities/article_entity.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.id,
    required super.title,
    required super.description,
    required super.webUrl,
    super.coverImageUrl,
    required super.publishedDate,
    required super.readingTimeMinutes,
    required super.tags,
    required super.authorName,
    super.authorProfileImageUrl,
    super.isBookmarked,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json, {bool isBookmarked = false}) {
    List<String> tagList = [];
    if (json['tag_list'] is List) {
      tagList = (json['tag_list'] as List).map((e) => e.toString()).toList();
    }

    return ArticleModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      webUrl: json['url'] ?? '',
      coverImageUrl: json['cover_image'],
      publishedDate: json['readable_publish_date'] ?? 'Recently',
      readingTimeMinutes: (json['reading_time_minutes'] as num?)?.toInt() ?? 1,
      tags: tagList,
      authorName: json['user'] != null ? (json['user']['name'] ?? 'Dev Community') : 'Dev Community',
      authorProfileImageUrl: json['user'] != null ? json['user']['profile_image'] : null,
      isBookmarked: isBookmarked,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'url': webUrl,
      'cover_image': coverImageUrl,
      'readable_publish_date': publishedDate,
      'reading_time_minutes': readingTimeMinutes,
      'tag_list': tags,
      'user': {
        'name': authorName,
        'profile_image': authorProfileImageUrl,
      },
      'is_bookmarked': isBookmarked,
    };
  }
}
