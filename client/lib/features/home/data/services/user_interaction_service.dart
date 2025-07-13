import 'package:dio/dio.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:client/features/home/data/models/article_model.dart';

class UserInteractionService {
  static const String _baseUrl = 'https://contactjoumal--snrt-semantic-api-fastapi-app.modal.run';
  static final Dio _dio = Dio();
  static final SupabaseClient _supabase = Supabase.instance.client;

  /// Record a user interaction in Supabase
  static Future<void> recordInteraction({
    required String userId,
    required int articleId,
    String interactionType = 'view',
    int interactionScore = 1,
  }) async {
    try {
      await _supabase.from('user_interactions').insert({
        'user_id': userId,
        'article_id': articleId,
        'interaction_type': interactionType,
        'interaction_score': interactionScore,
      });
    } catch (e) {
      print('Error recording interaction: $e');
    }
  }

  /// Get personalized recommendations from the API
  static Future<List<Article>> getRecommendations({
    required String userId,
    int topK = 10,
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/recommend',
        data: {
          'user_id': userId,
          'top_k': topK,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final results = data['results'] as List<dynamic>;
        
        return results.map<Article>((item) {
          final extra = item['extra'] ?? {};
          final imagePath = extra['image'] ?? '';
          final imageBaseUrl = 'https://cdn.snrtbotola.ma';
          
          return Article(
            id: item['id'] is int ? item['id'] : int.tryParse(item['id']?.toString() ?? '') ?? 0,
            title: item['title'] ?? '',
            description: item['description'] ?? '',
            resume: '',
            categorieLabel: extra['categorieLabel'] ?? 'News',
            image: imagePath.startsWith('http') ? imagePath : '$imageBaseUrl$imagePath',
            isVideo: item['type'] == 'video',
            video: null,
            typeVideo: null,
            competitionId: null,
            publishedAt: item['date'] != null
                ? DateTime.tryParse(item['date'].toString()) ?? DateTime.now()
                : DateTime.now(),
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      print('Error getting recommendations: $e');
      return [];
    }
  }

  /// Track article view interaction
  static Future<void> trackArticleView({
    required String userId,
    required int articleId,
  }) async {
    await recordInteraction(
      userId: userId,
      articleId: articleId,
      interactionType: 'view',
      interactionScore: 1,
    );
  }

  /// Track article click interaction
  static Future<void> trackArticleClick({
    required String userId,
    required int articleId,
  }) async {
    await recordInteraction(
      userId: userId,
      articleId: articleId,
      interactionType: 'click',
      interactionScore: 2,
    );
  }

  /// Track article share interaction
  static Future<void> trackArticleShare({
    required String userId,
    required int articleId,
  }) async {
    await recordInteraction(
      userId: userId,
      articleId: articleId,
      interactionType: 'share',
      interactionScore: 3,
    );
  }

  /// Track article read time (higher score for longer reads)
  static Future<void> trackArticleReadTime({
    required String userId,
    required int articleId,
    required int readTimeSeconds,
  }) async {
    // Score based on read time: 1 point per 30 seconds, max 5 points
    final score = (readTimeSeconds / 30).ceil().clamp(1, 5);
    
    await recordInteraction(
      userId: userId,
      articleId: articleId,
      interactionType: 'read_time',
      interactionScore: score,
    );
  }

  /// Fetch articles directly from Milvus vector database
  static Future<List<Article>> getArticlesFromMilvus({
    int limit = 10,
    int offset = 0,
    String articleType = 'article',
  }) async {
    try {
      final response = await _dio.post(
        '$_baseUrl/articles',
        data: {
          'limit': limit,
          'offset': offset,
          'article_type': articleType,
        },
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final articles = data['articles'] as List<dynamic>;
        
        return articles.map<Article>((item) {
          final extra = item['extra'] ?? {};
          // Try to get image from multiple sources
          String imagePath = item['image'] ?? extra['image'] ?? '';
          final imageBaseUrl = 'https://cdn.snrtbotola.ma';
          final finalImageUrl = imagePath.startsWith('http') ? imagePath : '$imageBaseUrl$imagePath';
          
          return Article(
            id: item['id'] is int ? item['id'] : int.tryParse(item['id']?.toString() ?? '') ?? 0,
            title: item['title'] ?? '',
            description: item['description'] ?? '',
            resume: '',
            categorieLabel: extra['categorieLabel'] ?? 'News',
            image: finalImageUrl,
            isVideo: item['type'] == 'video',
            video: null,
            typeVideo: null,
            competitionId: null,
            publishedAt: item['date'] != null
                ? DateTime.tryParse(item['date'].toString()) ?? DateTime.now()
                : DateTime.now(),
          );
        }).toList();
      }
      
      return [];
    } catch (e) {
      print('Error fetching articles from Milvus: $e');
      return [];
    }
  }
}
