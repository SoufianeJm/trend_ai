import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/article_detail/view/pages/article_detail_page.dart';

const _imageBaseUrl = 'https://cdn.snrtbotola.ma';

class PremiumNewsCard extends StatelessWidget {
  final Article article;
  final String? publisherName;
  final String? publisherLogo;
  final bool isVerified;

  const PremiumNewsCard({
    super.key,
    required this.article,
    this.publisherName,
    this.publisherLogo,
    this.isVerified = false,
  });

  @override
  Widget build(BuildContext context) {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final date = article.publishedAt;
    final formattedDate = '${months[date.month - 1]} ${date.day}, ${date.year}';
    
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleDetailPage(article: article),
          ),
        );
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Palette.gray200),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Section
              Row(
                children: [
                  // Publisher Info
                  Expanded(
                    child: Row(
                      children: [
                        // Publisher Logo
                        Container(
                          width: 32,
                          height: 32,
                          decoration: BoxDecoration(
                            color: Palette.gray100,
                            borderRadius: BorderRadius.circular(4),
                            image: publisherLogo != null
                                ? DecorationImage(
                                    image: NetworkImage(publisherLogo!),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                          ),
                          child: publisherLogo == null
                              ? Icon(
                                  Icons.article_outlined,
                                  size: 16,
                                  color: Palette.gray400,
                                )
                              : null,
                        ),
                        const SizedBox(width: 12),
                        // Publisher Name and Date
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      publisherName ?? 'SNRT News',
                                      style: AppTypography.bodyRegular14.copyWith(
                                        color: Palette.gray400,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  if (isVerified) ...[
                                    const SizedBox(width: 4),
                                    Icon(
                                      Icons.verified,
                                      size: 16,
                                      color: Palette.primary,
                                    ),
                                  ],
                                ],
                              ),
                              Text(
                                formattedDate,
                                style: AppTypography.bodyRegular12.copyWith(
                                  color: Palette.gray400,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Follow Button
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                    decoration: BoxDecoration(
                      color: Palette.gray200,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      'Follow',
                      style: AppTypography.bodyMedium12.copyWith(
                        color: Palette.gray900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // More Options
                  Container(
                    padding: const EdgeInsets.all(4),
                    child: Icon(
                      Icons.more_horiz,
                      size: 20,
                      color: Palette.gray400,
                    ),
                  ),
              ],
              ),
              
              const SizedBox(height: 12),
              
              // Title
              Text(
                article.title,
                style: AppTypography.bodyBold18.copyWith(
                  color: Palette.gray900,
                  height: 1.44,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Category Tag
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
                decoration: BoxDecoration(
                  border: Border.all(color: Palette.primary, width: 1),
                  borderRadius: BorderRadius.circular(5),
                ),
                child: Text(
                  article.categorieLabel,
                  style: AppTypography.bodyMedium12.copyWith(
                    color: Palette.primary,
                  ),
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Cover Image
              Container(
                width: double.infinity,
                height: 180,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(9),
                ),
                child: article.image.isNotEmpty
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(9),
                        child: Image.network(
                          '$_imageBaseUrl${article.image}',
                          width: double.infinity,
                          height: 180,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Container(
                            width: double.infinity,
                            height: 180,
                            color: Palette.gray100,
                            child: Center(
                              child: Icon(
                                Icons.image_outlined,
                                size: 48,
                                color: Palette.gray400,
                              ),
                            ),
                          ),
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: double.infinity,
                              height: 180,
                              color: Palette.gray100,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Palette.primary,
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                          loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                      )
                    : Container(
                        width: double.infinity,
                        height: 180,
                        color: Palette.gray100,
                        child: Center(
                          child: Icon(
                            Icons.image_outlined,
                            size: 48,
                            color: Palette.gray400,
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
