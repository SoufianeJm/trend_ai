import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/widgets/trending_article_card.dart';

class TrendingSection extends StatelessWidget {
  const TrendingSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trending',
          style: AppTypography.bodyMedium16.copyWith(
            color: Palette.gray900,
          ),
        ),
        const SizedBox(height: 16),
        const TrendingArticleCard(
          imageUrl: 'assets/images/trending1.webp',
          category: 'Technology',
          title:
              'Google Launches AI-Powered Virtual Assistant for Business...',
          meta: '21 Mar, 2024  -  9 min read',
        ),
        const TrendingArticleCard(
          imageUrl: 'assets/images/trending2.jpg',
          category: 'International',
          title:
              'North Korea Conducts Missile Tests, Prompting Internation...',
          meta: '21 Mar, 2024  -  9 min read',
        ),
      ],
    );
  }
}
