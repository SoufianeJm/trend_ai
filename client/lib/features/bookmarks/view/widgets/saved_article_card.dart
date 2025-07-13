import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/article_detail/view/pages/article_detail_page.dart';
import 'package:client/utils/date_utils.dart';
import 'package:client/features/bookmarks/data/services/bookmark_service.dart';

const _imageBaseUrl = 'https://cdn.snrtbotola.ma';

class SavedArticleCard extends StatefulWidget {
  final Article article;
  final VoidCallback? onRemoved;

  const SavedArticleCard({
    super.key,
    required this.article,
    this.onRemoved,
  });

  @override
  State<SavedArticleCard> createState() => _SavedArticleCardState();
}

class _SavedArticleCardState extends State<SavedArticleCard> {
  bool _isRemoving = false;

  Future<void> _removeBookmark() async {
    setState(() {
      _isRemoving = true;
    });

    final success = await BookmarkService.removeBookmark(widget.article.id);
    
    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Article removed from saved'),
          duration: Duration(seconds: 2),
          backgroundColor: Colors.orange,
        ),
      );
      
      // Notify parent to refresh the list
      widget.onRemoved?.call();
    } else if (mounted) {
      setState(() {
        _isRemoving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => ArticleDetailPage(article: widget.article),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Article Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  '$_imageBaseUrl${widget.article.image ?? ''}',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: Colors.grey[300],
                    child: const Icon(Icons.broken_image, size: 24),
                  ),
                ),
              ),
              
              const SizedBox(width: 12),
              
              // Article Content
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title
                    Text(
                      widget.article.title ?? 'Untitled',
                      style: AppTypography.bodyMedium14.copyWith(
                        color: Palette.gray900,
                        fontWeight: FontWeight.w600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    const SizedBox(height: 6),
                    
                    // Category and Time
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Palette.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            widget.article.categorieLabel ?? 'News',
                            style: AppTypography.bodyRegular10.copyWith(
                              color: Palette.primary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          timeAgoFromNow(widget.article.publishedAt ?? DateTime.now()),
                          style: AppTypography.bodyRegular10.copyWith(
                            color: Palette.gray400,
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 8),
                    
                    // Bottom Row with Publisher and Remove Button
                    Row(
                      children: [
                        // Publisher Info
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: BoxDecoration(
                                color: Palette.background,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: Palette.gray200),
                              ),
                              child: Image.asset(
                                'assets/icons/botola.png',
                                width: 12,
                                height: 12,
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Snrt Botola',
                              style: AppTypography.bodyRegular10.copyWith(
                                color: Palette.gray400,
                              ),
                            ),
                          ],
                        ),
                        
                        const Spacer(),
                        
                        // Remove Button
                        GestureDetector(
                          onTap: _isRemoving ? null : _removeBookmark,
                          child: Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: _isRemoving
                                ? const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Colors.red,
                                    ),
                                  )
                                : const Icon(
                                    Icons.bookmark_remove,
                                    size: 16,
                                    color: Colors.red,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
