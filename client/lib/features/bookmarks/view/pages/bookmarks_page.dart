import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/bookmarks/data/services/saved_articles_service.dart';
import 'package:client/features/bookmarks/view/widgets/saved_article_card.dart';
import 'package:client/features/home/data/models/article_model.dart';

class BookmarksPage extends StatefulWidget {
  const BookmarksPage({super.key});

  @override
  State<BookmarksPage> createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  List<Article> _savedArticles = [];
  bool _isLoadingSavedArticles = false;

  @override
  void initState() {
    super.initState();
    _loadSavedArticles();
  }

  Future<void> _loadSavedArticles() async {
    setState(() {
      _isLoadingSavedArticles = true;
    });
    
    try {
      final savedArticles = await SavedArticlesService.getSavedArticles();
      setState(() {
        _savedArticles = savedArticles;
        _isLoadingSavedArticles = false;
      });
    } catch (e) {
      print('Error loading saved articles: $e');
      setState(() {
        _isLoadingSavedArticles = false;
      });
    }
  }

  void _onArticleRemoved() {
    // Refresh the saved articles list when an article is removed
    _loadSavedArticles();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            // Simple App Bar
            Container(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: const Icon(
                      Icons.arrow_back_ios,
                      size: 24,
                      color: Palette.gray900,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    'Saved Articles',
                    style: AppTypography.bodyMedium18.copyWith(
                      color: Palette.gray900,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            
            // Content
            Expanded(
              child: _buildBookmarksContent(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookmarksContent() {
    if (_isLoadingSavedArticles) {
      return const Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(Palette.primary),
        ),
      );
    }

    if (_savedArticles.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.bookmark_border,
                size: 64,
                color: Palette.gray400,
              ),
              const SizedBox(height: 24),
              Text(
                'No Saved Articles',
                style: AppTypography.h5.copyWith(
                  color: Palette.gray900,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Save articles you want to read later by tapping the bookmark icon.',
                style: AppTypography.bodyRegular14.copyWith(
                  color: Palette.gray500,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Article count
          Text(
            '${_savedArticles.length} saved ${_savedArticles.length == 1 ? 'article' : 'articles'}',
            style: AppTypography.bodyRegular14.copyWith(
              color: Palette.gray500,
            ),
          ),
          const SizedBox(height: 16),
          
          // Articles list
          Expanded(
            child: ListView.builder(
              itemCount: _savedArticles.length,
              itemBuilder: (context, index) {
                return SavedArticleCard(
                  article: _savedArticles[index],
                  onRemoved: _onArticleRemoved,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
