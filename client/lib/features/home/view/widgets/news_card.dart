import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/article_detail/view/pages/article_detail_page.dart';
import 'package:client/utils/date_utils.dart';

const _imageBaseUrl = 'https://cdn.snrtbotola.ma';

class NewsCard extends StatelessWidget {
  final Article item;

  const NewsCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => ArticleDetailPage(article: item),
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
                    '$_imageBaseUrl${item.image}',
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
                  child: Image.asset(
                    'assets/icons/bookmark_empty.png',
                    width: 20,
                    height: 20,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Text(
                    item.categorieLabel,
                    style: AppTypography.bodyMedium10.copyWith(color: Palette.primary),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Row(
                  children: [
                    Image.asset('assets/icons/clock.png', width: 12, height: 12),
                    const SizedBox(width: 6),
                    Text(
                      timeAgoFromNow(item.publishedAt),
                      style: AppTypography.bodyRegular10.copyWith(color: Palette.gray400),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              item.title,
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
