import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/article_detail/view/pages/article_detail_page.dart';
import 'package:client/utils/date_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:client/features/bookmarks/data/services/bookmark_service.dart';

const _imageBaseUrl = 'https://cdn.snrtbotola.ma';

class NewsCard extends StatefulWidget {
  final Article item;

  const NewsCard({super.key, required this.item});

  @override
  State<NewsCard> createState() => _NewsCardState();
}

class _NewsCardState extends State<NewsCard> {
  bool _isBookmarked = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _checkBookmarkStatus();
  }

  Future<void> _checkBookmarkStatus() async {
    final isBookmarked = await BookmarkService.isBookmarked(widget.item.id);
    if (mounted) {
      setState(() {
        _isBookmarked = isBookmarked;
      });
    }
  }

  Future<void> _toggleBookmark() async {
    setState(() {
      _isLoading = true;
    });

    final success = await BookmarkService.toggleBookmark(widget.item.id);
    
    if (success && mounted) {
      setState(() {
        _isBookmarked = !_isBookmarked;
        _isLoading = false;
      });

      // Show feedback to user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isBookmarked ? 'Article saved!' : 'Article removed from saved',
          ),
          duration: const Duration(seconds: 2),
          backgroundColor: _isBookmarked ? Colors.green : Colors.orange,
        ),
      );
    } else if (mounted) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleDetailPage(article: widget.item),
          ),
        );
      },
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.network(
                    '$_imageBaseUrl${widget.item.image}',
                    height: 140,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      height: 140,
                      color: Colors.grey[300],
                      child: const Icon(Icons.broken_image),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: GestureDetector(
                    onTap: _toggleBookmark,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                      ),
                      child: _isLoading
                          ? const Center(
                              child: SizedBox(
                                width: 12,
                                height: 12,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Palette.primary,
                                ),
                              ),
                            )
                          : Icon(
                              _isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              size: 16,
                              color: _isBookmarked ? Palette.primary : Colors.grey[600],
                            ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    widget.item.categorieLabel,
                    style: AppTypography.bodyMedium10.copyWith(color: Palette.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/clock.png', width: 12, height: 12),
                    const SizedBox(width: 6),
                    Text(
                      timeAgoFromNow(widget.item.publishedAt),
                      style: AppTypography.bodyRegular10.copyWith(color: Palette.gray400),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              widget.item.title,
              style: AppTypography.bodyMedium14.copyWith(color: Palette.gray900),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(3),
                  decoration: BoxDecoration(
                    color: Palette.background,
                    borderRadius: BorderRadius.circular(100),
                    border: Border.all(color: Palette.gray200, width: 1),
                  ),
                  child: Image.asset(
                    'assets/icons/botola.png',
                    width: 12,
                    height: 12,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Snrt Botola',
                  style: AppTypography.bodyMedium10.copyWith(color: Palette.gray400),
                ),
                const Spacer(),
                Image.asset('assets/icons/more.png', width: 16, height: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class NewsCardSkeleton extends StatelessWidget {
  const NewsCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Palette.gray100,
      highlightColor: Palette.gray200,
      child: SizedBox(
        width: 240,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Container(
                    height: 140,
                    width: double.infinity,
                    color: Palette.gray100,
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Palette.gray200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 12,
                    color: Palette.gray100,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 12,
                  height: 12,
                  color: Palette.gray100,
                ),
                const SizedBox(width: 6),
                Container(
                  width: 40,
                  height: 10,
                  color: Palette.gray100,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Container(
              height: 16,
              width: double.infinity,
              color: Palette.gray100,
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Container(
                  width: 18,
                  height: 18,
                  decoration: BoxDecoration(
                    color: Palette.gray100,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 60,
                  height: 10,
                  color: Palette.gray100,
                ),
                const Spacer(),
                Container(
                  width: 16,
                  height: 16,
                  color: Palette.gray100,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
