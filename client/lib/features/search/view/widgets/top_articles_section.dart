import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/article_detail/view/pages/article_detail_page.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/search/service/search_service.dart';
import 'package:shimmer/shimmer.dart';

const _imageBaseUrl = 'https://cdn.snrtbotola.ma';

class TopArticlesSection extends StatefulWidget {
  final String query;
  final void Function(bool hasResults)? onResult;
  const TopArticlesSection({super.key, required this.query, this.onResult});

  @override
  State<TopArticlesSection> createState() => _TopArticlesSectionState();
}

class _TopArticlesSectionState extends State<TopArticlesSection> {
  List<Article> _articles = [];
  bool _isLoading = true;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _fetchTopArticles();
  }

  Future<void> _fetchTopArticles() async {
    setState(() {
      _isLoading = true;
      _hasError = false;
    });
    try {
      final result = await SearchService.search(widget.query);
      final results = result['results'] ?? [];

      final articles = results
          .where((item) => item['type'] == 'article')
          .map<Article>((item) {
        final extra = item['extra'] ?? {};
        final imagePath = extra['image'] ?? '';
        return Article(
          id: item['id'] is int ? item['id'] : int.tryParse(item['id']?.toString() ?? '') ?? 0,
          title: item['title'] ?? '',
          description: item['description'] ?? '',
          resume: '',
          categorieLabel: extra['categorieLabel'] ?? 'News',
          image: imagePath.startsWith('http') ? imagePath : '$_imageBaseUrl$imagePath',
          isVideo: false,
          video: null,
          typeVideo: null,
          competitionId: null,
          publishedAt: item['date'] != null
              ? DateTime.tryParse(item['date'].toString()) ?? DateTime.now()
              : DateTime.now(),
        );
      }).take(5).toList();

      setState(() {
        _articles = articles;
        _isLoading = false;
        widget.onResult?.call(_articles.isNotEmpty);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _hasError = true;
        widget.onResult?.call(false);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final cardWidth = MediaQuery.of(context).size.width * 0.6;

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
          child: _isLoading
              ? Shimmer.fromColors(
                  baseColor: Palette.gray100,
                  highlightColor: Palette.gray200,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: 3,
                    separatorBuilder: (_, __) => const SizedBox(width: 12),
                    itemBuilder: (context, index) {
                      return Container(
                        width: cardWidth,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          border: Border.all(color: Palette.gray200),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Container(
                                width: double.infinity,
                                height: 94,
                                color: Palette.gray100,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Container(height: 12, width: 60, color: Palette.gray100),
                            const SizedBox(height: 4),
                            Container(height: 16, width: double.infinity, color: Palette.gray100),
                            const SizedBox(height: 8),
                            Container(height: 10, width: 40, color: Palette.gray100),
                          ],
                        ),
                      );
                    },
                  ),
                )
              : _hasError
                  ? const Center(child: Text('Failed to load articles'))
                  : _articles.isEmpty
                      ? const Center(child: Text('No articles found'))
                      : ListView.separated(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          itemCount: _articles.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 12),
                          itemBuilder: (context, index) {
                            final article = _articles[index];
                            return InkWell(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ArticleDetailPage(article: article),
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
                                      child: article.image != ''
                                          ? Image.network(
                                              article.image,
                                              width: cardWidth - 16,
                                              height: 120,
                                              fit: BoxFit.cover,
                                              errorBuilder: (_, __, ___) => Container(
                                                width: cardWidth - 16,
                                                height: 120,
                                                color: Palette.gray100,
                                                child: const Icon(Icons.broken_image, size: 40, color: Palette.gray400),
                                              ),
                                            )
                                          : Container(
                                              width: cardWidth - 16,
                                              height: 120,
                                              color: Palette.gray100,
                                              child: const Icon(Icons.image, size: 40, color: Palette.gray400),
                                            ),
                                    ),
                                    const SizedBox(height: 10),
                                    Text(
                                      article.title,
                                      style: AppTypography.bodyMedium16.copyWith(
                                        color: Palette.gray900,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      maxLines: 2,
                                    ),
                                    const SizedBox(height: 8),
                                    Container(height: 1, width: double.infinity, color: Palette.gray100),
                                    const SizedBox(height: 10),
                                    Row(
                                      children: [
                                        Text(
                                          '', // you can format article.publishedAt if needed
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
