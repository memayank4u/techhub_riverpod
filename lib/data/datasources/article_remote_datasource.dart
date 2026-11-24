import 'package:dio/dio.dart';
import '../../core/network/dio_client.dart';
import '../models/article_model.dart';

abstract class ArticleRemoteDataSource {
  Future<List<ArticleModel>> fetchArticles();
}

class ArticleRemoteDataSourceImpl implements ArticleRemoteDataSource {
  final DioClient dioClient;

  ArticleRemoteDataSourceImpl(this.dioClient);

  static const String endpoint = 'https://dev.to/api/articles?per_page=30';

  @override
  Future<List<ArticleModel>> fetchArticles() async {
    try {
      final response = await dioClient.get(endpoint);

      if (response.statusCode == 200) {
        final dynamic rawData = response.data;
        final List<dynamic> list = rawData is List ? rawData : [];
        return list.map((item) => ArticleModel.fromJson(item as Map<String, dynamic>)).toList();
      } else {
        throw Exception('Dev.to error: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception(e.message ?? 'Network error connecting to Dev.to');
    }
  }
}
