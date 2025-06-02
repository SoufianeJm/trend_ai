import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/widgets/search_app_bar.dart';
import 'package:client/features/search/view/widgets/search_widget.dart';
import 'package:client/features/search/view/widgets/trending_article_card.dart';

class SearchResultsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SearchResultsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();
    final List<dynamic> results = data['results'] ?? [];

    final List<Map<String, dynamic>> articles = results
        .where((item) => item['type'] == 'article')
        .cast<Map<String, dynamic>>()
        .toList();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const SearchAppBar(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchPageSearchBar(
                controller: controller,
                onFilterTap: () {},
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Results',
                style: AppTypography.bodyMedium16.copyWith(
                  color: Palette.gray900,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: articles.isEmpty
                  ? const Center(
                      child: Text(
                        'No results found.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: articles.length,
                      itemBuilder: (_, index) {
                        final article = articles[index];
                        final extra = article['extra'] ?? {};
                        final imageUrl =
                            'https://cdn.snrtbotola.ma${extra['image'] ?? ''}';
                        final date = article['date'] ?? '';
                        final time = article['time'] ?? '';

                        return TrendingArticleCard(
                          imageUrl: imageUrl,
                          category: extra['categorieLabel'] ?? 'News',
                          title: article['title'] ?? '',
                          meta: '$date  -  $time',
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
