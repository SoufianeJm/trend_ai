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
    final TextEditingController controller = TextEditingController();
    final List<dynamic> results = data['results'] ?? [];

    final List<dynamic> articleResults = results
        .where((item) => item['type'] == 'article')
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
              child: articleResults.isEmpty
                  ? const Center(
                      child: Text('No results found'),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      itemCount: articleResults.length,
                      itemBuilder: (context, index) {
                        final article = articleResults[index];
                        final extra = article['extra'] ?? {};

                        return TrendingArticleCard(
                          imageUrl:
                              'https://cdn.snrtbotola.ma${extra['image'] ?? ''}',
                          category: extra['categorieLabel']?.toString().isEmpty ?? true
                              ? 'Article'
                              : extra['categorieLabel'],
                          title: article['title'] ?? '',
                          meta:
                              '${article['date'] ?? ''}  -  ${article['time']?.substring(0, 5) ?? ''}',
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
