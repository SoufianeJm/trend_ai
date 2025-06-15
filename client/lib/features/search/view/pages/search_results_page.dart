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
import 'package:client/features/search/view/pages/search_page.dart';

class SearchResultsPage extends StatefulWidget {
  final Map<String, dynamic> data;

  const SearchResultsPage({super.key, required this.data});

  @override
  State<SearchResultsPage> createState() => _SearchResultsPageState();
}

class _SearchResultsPageState extends State<SearchResultsPage> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, dynamic>> _articles = [];
  bool _hasArticleResults = true;
  bool _hasVideoResults = true;

  @override
  void initState() {
    super.initState();
    _controller.text = widget.data['query'] ?? '';
    _performSearch(_controller.text);
  }

  void _extractArticles(Map<String, dynamic> data) {
    final results = data['results'] ?? [];
    setState(() {
      _articles = results
          .where((item) => item['type'] == 'article')
          .map<Map<String, dynamic>>((item) {
            final extra = item['extra'] ?? {};
            return {
              'title': item['title'] ?? '',
              'imageUrl': extra['image'] != null ? 'https://cdn.snrtbotola.ma${extra['image']}' : '',
              'category': extra['categorieLabel'] ?? 'News',
              'meta': '', // Placeholder, update if needed
            };
          })
          .toList();
      _hasArticleResults = _articles.isNotEmpty;
    });
  }

  void _onArticlesResult(bool hasResults) {
    setState(() {
      _hasArticleResults = hasResults;
    });
  }

  void _onVideosResult(bool hasResults) {
    setState(() {
      _hasVideoResults = hasResults;
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
                child: GestureDetector(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(builder: (_) => const SearchPage()),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Palette.gray200, width: 1),
                    ),
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/icons/search.png',
                          width: 20,
                          height: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _controller.text.isNotEmpty ? _controller.text : 'Search article...',
                            style: AppTypography.bodyMedium14.copyWith(color: Palette.gray900),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Image.asset(
                          'assets/icons/filter.png',
                          width: 20,
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: CategoryChipsBar(),
              ),
              if (_hasArticleResults)
                TopArticlesSection(
                  query: _controller.text,
                  onResult: _onArticlesResult,
                ),
              if (_hasArticleResults) const SizedBox(height: 12),
              if (_hasVideoResults)
                TopVideosSection(
                  query: _controller.text,
                  onResult: _onVideosResult,
                ),
              if (!_hasArticleResults && !_hasVideoResults)
                const Center(
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 48),
                    child: Text(
                      'No results found.',
                      style: TextStyle(color: Colors.grey, fontSize: 18),
                    ),
                  ),
                ),
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
                          final imageUrl = article['imageUrl'] ?? '';
                          final category = article['category'] ?? 'News';
                          final title = article['title'] ?? '';
                          final meta = article['meta'] ?? '';
                          return TrendingArticleCard(
                            imageUrl: imageUrl,
                            category: category,
                            title: title,
                            meta: meta,
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
