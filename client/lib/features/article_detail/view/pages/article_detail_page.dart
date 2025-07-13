import 'package:flutter/material.dart';
import 'package:client/features/article_detail/view/widgets/article_image.dart';
import 'package:client/features/article_detail/view/widgets/publisher_row.dart';
import 'package:client/features/article_detail/view/widgets/article_title.dart';
import 'package:client/features/article_detail/view/widgets/meta_row.dart';
import 'package:client/features/article_detail/view/widgets/article_content.dart';
import 'package:client/features/article_detail/view/widgets/comment_input.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/data/services/user_interaction_service.dart';
import 'package:client/core/services/user_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ArticleDetailPage extends StatefulWidget {
  final Article article;

  const ArticleDetailPage({super.key, required this.article});

  @override
  State<ArticleDetailPage> createState() => _ArticleDetailPageState();
}

class _ArticleDetailPageState extends State<ArticleDetailPage> {
  DateTime? _pageOpenTime;
  String? _currentUserId;

  @override
  void initState() {
    super.initState();
    _pageOpenTime = DateTime.now();
    _initializeUserTracking();
  }

  @override
  void dispose() {
    _trackReadTime();
    super.dispose();
  }

  Future<void> _initializeUserTracking() async {
    try {
      final user = Supabase.instance.client.auth.currentUser;
      if (user != null) {
        _currentUserId = user.id;
      } else {
        _currentUserId = await UserService.getOrGenerateUsername();
      }
      
      // Track article view
      if (_currentUserId != null) {
        await UserInteractionService.trackArticleView(
          userId: _currentUserId!,
          articleId: widget.article.id,
        );
      }
    } catch (e) {
      print('Error initializing user tracking: $e');
    }
  }

  Future<void> _trackReadTime() async {
    if (_pageOpenTime != null && _currentUserId != null) {
      final readTime = DateTime.now().difference(_pageOpenTime!).inSeconds;
      if (readTime > 5) { // Only track if user stayed for more than 5 seconds
        await UserInteractionService.trackArticleReadTime(
          userId: _currentUserId!,
          articleId: widget.article.id,
          readTimeSeconds: readTime,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Palette.white,
      body: Stack(
        children: [
          // Scrollable content
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 80),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top image with overlay
                Stack(
                  children: [
                    ArticleImage(article: widget.article),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      child: SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              _circleIconButton(
                                icon: Icons.arrow_back,
                                onTap: () => Navigator.of(context).pop(),
                              ),
                              _circleIconButton(
                                icon: Icons.more_horiz,
                                onTap: () {},
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const PublisherRow(), // Hardcoded as per your request
                      const SizedBox(height: 24),
                      ArticleTitle(title: widget.article.title ?? 'Untitled'),
                      const SizedBox(height: 20),
                      MetaRow(article: widget.article),
                      const SizedBox(height: 20),
                      ArticleContent(content: widget.article.description ?? 'No description available'),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomSheet: SafeArea(
        child: Container(
          color: Palette.background,
          padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
          child: const CommentInput(),
        ),
      ),
    );
  }

  Widget _circleIconButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.28),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }
}
