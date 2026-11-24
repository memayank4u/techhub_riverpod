import 'package:equatable/equatable.dart';

class ArticleEntity extends Equatable {
  final int id;
  final String title;
  final String description;
  final String webUrl;
  final String? coverImageUrl;
  final String publishedDate;
  final int readingTimeMinutes;
  final List<String> tags;
  final String authorName;
  final String? authorProfileImageUrl;
  final bool isBookmarked;

  const ArticleEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.webUrl,
    this.coverImageUrl,
    required this.publishedDate,
    required this.readingTimeMinutes,
    required this.tags,
    required this.authorName,
    this.authorProfileImageUrl,
    this.isBookmarked = false,
  });

  ArticleEntity copyWith({bool? isBookmarked}) {
    return ArticleEntity(
      id: id,
      title: title,
      description: description,
      webUrl: webUrl,
      coverImageUrl: coverImageUrl,
      publishedDate: publishedDate,
      readingTimeMinutes: readingTimeMinutes,
      tags: tags,
      authorName: authorName,
      authorProfileImageUrl: authorProfileImageUrl,
      isBookmarked: isBookmarked ?? this.isBookmarked,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        webUrl,
        coverImageUrl,
        publishedDate,
        readingTimeMinutes,
        tags,
        authorName,
        authorProfileImageUrl,
        isBookmarked,
      ];
}
