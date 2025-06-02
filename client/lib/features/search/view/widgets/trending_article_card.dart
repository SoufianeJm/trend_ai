import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class TrendingArticleCard extends StatelessWidget {
  final String imageUrl;
  final String category;
  final String title;
  final String meta;

  const TrendingArticleCard({
    super.key,
    required this.imageUrl,
    required this.category,
    required this.title,
    required this.meta,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Palette.gray200),
        borderRadius: BorderRadius.circular(16),
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
              imageUrl,
              width: 72,
              fit: BoxFit.cover,
            )
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category,
                    style: AppTypography.bodyBold12.copyWith(color: Palette.primary),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: AppTypography.bodyBold14.copyWith(color: Palette.gray900),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    meta,
                    style: AppTypography.bodyRegular10.copyWith(color: Palette.gray400),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
