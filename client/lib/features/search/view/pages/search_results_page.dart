import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/widgets/search_app_bar.dart';
import 'package:client/features/search/view/widgets/search_widget.dart';
import 'package:client/features/search/view/widgets/trending_article_card.dart';
import 'package:client/features/search/service/search_service.dart';
import 'package:client/features/search/view/widgets/category_chips_bar.dart';
import 'package:client/features/search/view/widgets/top_articles_section.dart';
import 'package:client/features/search/view/widgets/top_videos_section.dart';

class SearchResultsPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const SearchResultsPage({super.key, required this.data});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _articles = [];

  @override
  void initState() {
    super.initState();
    _controller.text = widget.data['query'] ?? '';
    _extractArticles(widget.data);
  }

  void _extractArticles(Map<String, dynamic> data) {
    final results = data['results'] ?? [];
    setState(() {
      _articles = results
          .where((item) => item['type'] == 'article')
          .cast<Map<String, dynamic>>()
          .toList();
    });
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) return;

    try {
      final result = await SearchService.search(query.trim());
      _extractArticles(result);
    } catch (e) {
      debugPrint('❌ Search error: $e');
      setState(() => _articles = []);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: SearchAppBar(),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: SearchPageSearchBar(
                  controller: _controller,
                  onFilterTap: () => _performSearch(_controller.text),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CategoryChipsBar(),
              ),
              TopArticlesSection(),
              const SizedBox(height: 12),
              TopVideosSection(),
              // The following is commented out as per new requirements:
              /*
              Expanded(
                child: _articles.isEmpty
                    ? const Center(
                        child: Text(
                          'No results found.',
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        itemCount: _articles.length,
                        itemBuilder: (_, index) {
                          final article = _articles[index];
                          final extra = article['extra'] ?? {};
                          final imageUrl =
                              'https://cdn.snrtbotola.ma"+extra['image'] ?? ''}';
                          final date = article['date'] ?? '';
                          final time = article['time'] ?? '';
  
                          return TrendingArticleCard(
                            imageUrl: imageUrl,
                            category: extra['categorieLabel'] ?? 'News',
                            title: article['title'] ?? '',
                            meta: '\u000020-\u000020',
                          );
                        },
                      ),
              ),
              */
            ],
          ),
        ),
      ),
    );
  }
}
