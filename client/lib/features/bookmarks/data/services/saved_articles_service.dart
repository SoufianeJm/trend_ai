import 'package:client/features/bookmarks/data/services/bookmark_service.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/data/repositories/home_repository.dart';
import 'package:client/core/network/dio_client.dart';

class SavedArticlesService {
  static final HomeRepository _homeRepository = HomeRepository(DioClient(baseUrl: 'https://api.snrtbotola.ma'));
  
  /// Get all saved articles with full article data
  static Future<List<Article>> getSavedArticles() async {
    try {
      // Get bookmarked article IDs
      final bookmarkedIds = await BookmarkService.getBookmarkedArticleIds();
      
      if (bookmarkedIds.isEmpty) {
        return [];
      }
      
      // Fetch all articles from the API
      final allArticles = await _homeRepository.getPaginatedArticles(
        pageNo: 0,
        pageSize: 1000000, // Get all articles to find our bookmarked ones
      );
      
      // Filter to only include bookmarked articles
      final savedArticles = allArticles.where((article) {
        return bookmarkedIds.contains(article.id);
      }).toList();
      
      // Sort by bookmark creation date (most recent first)
      // Since we can't easily get bookmark creation time, we'll sort by article publication date
      savedArticles.sort((a, b) => (b.publishedAt ?? DateTime.now()).compareTo(a.publishedAt ?? DateTime.now()));
      
      return savedArticles;
    } catch (e) {
      print('❌ Error fetching saved articles: $e');
      return [];
    }
  }
}
