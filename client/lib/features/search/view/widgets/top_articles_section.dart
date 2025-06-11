import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/article_detail/view/pages/article_detail_page.dart';
import 'package:client/features/home/data/models/article_model.dart';

class TopArticlesSection extends StatelessWidget {
  const TopArticlesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final articles = [
      {
        'image': 'assets/images/trending1.webp',
        'category': 'Sports',
        'time': '12 min ago',
        'title': 'Prix Marc-Vivien Foé 2025 Achraf Hakimi élu...',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/trending2.jpg',
        'category': 'Sports',
        'time': '10 min ago',
        'title': 'Another trending article headline goes here...',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/news_ronaldo.webp',
        'category': 'Sports',
        'time': '8 min ago',
        'title': 'Cristiano Ronaldo makes history again...',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/news_sample.webp',
        'category': 'News',
        'time': '5 min ago',
        'title': 'Sample news article headline for testing...',
        'publisher': 'Snrt News',
      },
      {
        'image': 'assets/images/news_movie.jpeg',
        'category': 'Movies',
        'time': '2 min ago',
        'title': 'Movie news: New blockbuster announced...',
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
              Text(
                'view more',
                style: AppTypography.bodyMedium14.copyWith(color: Palette.gray500),
              ),
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
              final cardWidth = MediaQuery.of(context).size.width * 0.6;

              return InkWell(
                onTap: () {
                  final mockArticle = Article(
                    id: index,
                    title: article['title']!,
                    description: '',
                    resume: '',
                    categorieLabel: article['category']!,
                    image: '', // No CDN path available for local assets
                    isVideo: false,
                    video: null,
                    typeVideo: null,
                    competitionId: null,
                    publishedAt: DateTime.now(),
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ArticleDetailPage(article: mockArticle),
                    ),
                  );
                },
                child: Container(
                  width: cardWidth,
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Palette.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Palette.gray200, width: 1),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(
                          article['image']!,
                          width: cardWidth - 16,
                          height: 120,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        article['title']!,
                        style: AppTypography.bodyMedium16.copyWith(
                          color: Palette.gray900,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 2,
                      ),
                      const SizedBox(height: 8),
                      Container(
                        width: double.infinity,
                        height: 1,
                        color: Palette.gray100,
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Text(
                            article['time']!,
                            style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400),
                          ),
                          const Spacer(),
                          Icon(Icons.more_horiz, size: 24, color: Palette.gray400),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
