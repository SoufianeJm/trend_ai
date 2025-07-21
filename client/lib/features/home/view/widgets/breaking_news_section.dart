import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/data/services/user_interaction_service.dart';
import 'package:client/features/home/view/widgets/news_card.dart';
import 'package:client/features/home/view/widgets/news_card_list.dart';
import 'package:client/core/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class BreakingNewsSection extends StatefulWidget {
  const BreakingNewsSection({super.key});

  @override
  State<BreakingNewsSection> createState() => _BreakingNewsSectionState();
}

class _BreakingNewsSectionState extends State<BreakingNewsSection> {
  List<Article> _articles = [];
  bool _isLoading = true;
  bool _isRefreshing = false;
  bool _useRecommendations = false;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  Future<void> _loadInitialData() async {
    await _getCurrentUser();
    await _loadBreakingNews();
  }

  Future<void> _getCurrentUser() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        _currentUserId = user.id;
      } else {
        // Use guest user ID if no authenticated user
        _currentUserId = await UserService.getOrGenerateUsername();
      }
    } catch (e) {
      print('Error getting current user: $e');
      _currentUserId = await UserService.getOrGenerateUsername();
    }
  }

  Future<void> _loadBreakingNews() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Article> articles = [];

      // Try to get recommendations first if user has interactions
      if (_currentUserId != null) {
        articles = await UserInteractionService.getRecommendations(
          userId: _currentUserId!,
          topK: 5,
        );
      }

      // If no recommendations, fall back to articles from Milvus
      if (articles.isEmpty) {
        articles = await UserInteractionService.getArticlesFromMilvus(
          limit: 10,
          offset: 0,
          articleType: 'article',
        );
        _useRecommendations = false;
      } else {
        _useRecommendations = true;
      }

      if (mounted) {
        setState(() {
          _articles = articles;
          _isLoading = false;
        });
      }
    } catch (e) {
      print('Error loading breaking news: $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _refreshNews() async {
    if (_isRefreshing || !mounted) return;

    setState(() {
      _isRefreshing = true;
    });

    try {
      // Force refresh recommendations if we have a user
      if (_currentUserId != null) {
        final recommendations = await UserInteractionService.getRecommendations(
          userId: _currentUserId!,
          topK: 5,
        );

        if (recommendations.isNotEmpty) {
          setState(() {
            _articles = recommendations;
            _useRecommendations = true;
            _isRefreshing = false;
          });

          // Show feedback to user
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Personalized recommendations loaded!'),
                duration: Duration(seconds: 2),
                backgroundColor: Palette.primary,
              ),
            );
          }
          return;
        }
      }

      // Fall back to articles from Milvus if no recommendations
      final articles = await UserInteractionService.getArticlesFromMilvus(
        limit: 10,
        offset: 0,
        articleType: 'article',
      );

      if (mounted) {
        setState(() {
          _articles = articles;
          _useRecommendations = false;
          _isRefreshing = false;
        });
      }
    } catch (e) {
      print('Error refreshing news: $e');
      if (mounted) {
        setState(() {
          _isRefreshing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header with Refresh Button
        Row(
          children: [
            Text(
              'For You',
              style: AppTypography.bodyMedium18.copyWith(
                color: Palette.gray900,
              ),
            ),
            if (_useRecommendations) ...[
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Palette.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Personalized',
                  style: AppTypography.bodyRegular10.copyWith(
                    color: Palette.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
            const Spacer(),
            GestureDetector(
              onTap: _isRefreshing ? null : _refreshNews,
              child: _isRefreshing
                  ? SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          Palette.primary,
                        ),
                      ),
                    )
                  : Text(
                      'Refresh',
                      style: AppTypography.bodyRegular12.copyWith(
                        color: Palette.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // News Content
        if (_isLoading)
          SizedBox(
            height: 270,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: 3,
              itemBuilder: (_, __) =>
                  const SizedBox(width: 199, child: NewsCardSkeleton()),
              separatorBuilder: (_, __) => const SizedBox(width: 16),
            ),
          )
        else if (_articles.isEmpty)
          Center(
            child: Column(
              children: [
                const SizedBox(height: 40),
                Text(
                  'No articles found',
                  style: AppTypography.bodyRegular14.copyWith(
                    color: Palette.gray500,
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _refreshNews,
                  child: Text(
                    'Tap to refresh',
                    style: AppTypography.bodyRegular12.copyWith(
                      color: Palette.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            ),
          )
        else
          NewsCardList(
            articles: _articles,
            onArticleClick: (article) {
              // Track article click interaction
              if (_currentUserId != null) {
                UserInteractionService.trackArticleClick(
                  userId: _currentUserId!,
                  articleId: article.id,
                );
              }
            },
          ),
      ],
    );
  }
}
