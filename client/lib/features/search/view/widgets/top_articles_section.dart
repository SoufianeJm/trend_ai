import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class TopArticlesSection extends StatelessWidget {
  const TopArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    // Placeholder data with local assets
    final articles = [
      {
        'image': 'assets/images/trending1.webp',
        'category': 'Sports',
        'time': '12 min ago',
        'title': 'Prix Marc-Vivien Foé 2025.. Achraf Hakimi élu...',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/trending2.jpg',
        'category': 'Sports',
        'time': '10 min ago',
        'title': 'Another trending article headline goes here...',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/news_ronaldo.webp',
        'category': 'Sports',
        'time': '8 min ago',
        'title': 'Cristiano Ronaldo makes history again...',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/news_sample.webp',
        'category': 'News',
        'time': '5 min ago',
        'title': 'Sample news article headline for testing...',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/news_movie.jpeg',
        'category': 'Movies',
        'time': '2 min ago',
        'title': 'Movie news: New blockbuster announced...',
        'publisherLogo': 'assets/icons/news.png',
        'publisher': 'Snrt News',
      },
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Top articles', style: AppTypography.bodyBold16),
              Text('view more', style: AppTypography.bodyMedium14.copyWith(color: Palette.gray500)),
            ],
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 240,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: articles.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) {
              final article = articles[index];
              return Container(
                width: 210,
                height: 240,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Palette.gray200, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        article['image']!,
                        width: double.infinity,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 14),
                    // Category+Time+Title block
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              article['category']!,
                              style: AppTypography.bodyMedium12.copyWith(color: Palette.primary),
                            ),
                            const Spacer(),
                            Icon(Icons.access_time, size: 14, color: Palette.gray400),
                            const SizedBox(width: 6),
                            Text(
                              article['time']!,
                              style: AppTypography.bodyMedium12.copyWith(color: Palette.gray400),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          article['title']!,
                          style: AppTypography.bodyMedium14.copyWith(color: Palette.gray700),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    // Publisher row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Palette.background,
                            shape: BoxShape.circle,
                            border: Border.all(color: Palette.gray200, width: 1),
                          ),
                          child: ClipOval(
                            child: Image.asset(
                              article['publisherLogo']!,
                              width: 14,
                              height: 14,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          article['publisher']!,
                          style: AppTypography.bodyMedium12.copyWith(color: Palette.gray400),
                        ),
                        const Spacer(),
                        Icon(Icons.more_horiz, size: 24, color: Palette.gray300),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
} 