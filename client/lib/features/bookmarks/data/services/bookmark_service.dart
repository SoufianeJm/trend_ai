import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:client/core/services/user_service.dart';
import 'package:client/features/bookmarks/data/models/bookmark_model.dart';
import 'package:client/features/home/data/models/article_model.dart';

class BookmarkService {
  static final _supabase = Supabase.instance.client;
  
  // Add a bookmark
  static Future<bool> addBookmark(int articleId) async {
    try {
      final userId = await UserService.getOrGenerateUsername();
      
      final response = await _supabase
          .from('bookmarks')
          .insert({
            'user_id': userId,
            'article_id': articleId,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      
      print('✅ Bookmark added: ${response}');
      return true;
    } catch (e) {
      print('❌ Error adding bookmark: $e');
      return false;
    }
  }
  
  // Remove a bookmark
  static Future<bool> removeBookmark(int articleId) async {
    try {
      final userId = await UserService.getOrGenerateUsername();
      
      await _supabase
          .from('bookmarks')
          .delete()
          .eq('user_id', userId)
          .eq('article_id', articleId);
      
      print('✅ Bookmark removed for article: $articleId');
      return true;
    } catch (e) {
      print('❌ Error removing bookmark: $e');
      return false;
    }
  }
  
  // Check if an article is bookmarked
  static Future<bool> isBookmarked(int articleId) async {
    try {
      final userId = await UserService.getOrGenerateUsername();
      
      final response = await _supabase
          .from('bookmarks')
          .select('id')
          .eq('user_id', userId)
          .eq('article_id', articleId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      print('❌ Error checking bookmark: $e');
      return false;
    }
  }
  
  // Get all bookmarked articles for a user
  static Future<List<int>> getBookmarkedArticleIds() async {
    try {
      final userId = await UserService.getOrGenerateUsername();
      
      final response = await _supabase
          .from('bookmarks')
          .select('article_id')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((item) => item['article_id'] as int)
          .toList();
    } catch (e) {
      print('❌ Error getting bookmarked articles: $e');
      return [];
    }
  }
  
  // Get all bookmarks with article details
  static Future<List<Bookmark>> getUserBookmarks() async {
    try {
      final userId = await UserService.getOrGenerateUsername();
      
      final response = await _supabase
          .from('bookmarks')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((item) => Bookmark.fromJson(item))
          .toList();
    } catch (e) {
      print('❌ Error getting user bookmarks: $e');
      return [];
    }
  }
  
  // Toggle bookmark status
  static Future<bool> toggleBookmark(int articleId) async {
    final isCurrentlyBookmarked = await isBookmarked(articleId);
    
    if (isCurrentlyBookmarked) {
      return await removeBookmark(articleId);
    } else {
      return await addBookmark(articleId);
    }
  }
}
