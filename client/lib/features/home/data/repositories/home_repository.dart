import 'package:dio/dio.dart';
import 'package:client/core/network/dio_client.dart';
import '../models/article_model.dart';

class HomeRepository {
  final DioClient dio;

  HomeRepository(this.dio);

  Future<List<Article>> getLatestArticles() async {
  final response = await dio.get(
    '/api-fo/articles-videos',
    queryParameters: {
      "pageNo": 0,
      "lang": "fr",
      "pageSize": 1000000,
      "rowSize": 2,
      "type": "all",
    },
  );

  try {
    final json = response.data as Map<String, dynamic>;
    final content = json['content'] as List<dynamic>;

    return content
        .map((item) {
          try {
            return Article.fromJson(item as Map<String, dynamic>);
          } catch (e, st) {
            print('❌ Error parsing article: $e\n$st\nitem: $item');
            return null;
          }
        })
        .whereType<Article>()
        .where((article) =>
            article.isVideo == false &&
            article.image.trim().isNotEmpty)
        .take(3)
        .toList();
  } catch (e, st) {
    print('❌ Error fetching articles: $e\n$st');
    rethrow;
  }
}

}
