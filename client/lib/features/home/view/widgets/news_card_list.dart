import 'package:flutter/material.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/view/widgets/news_card.dart';

class NewsCardList extends StatelessWidget {
  final List<Article> articles;
  final Function(Article)? onArticleClick;
  const NewsCardList({super.key, required this.articles, this.onArticleClick});

  @override
  Widget build(BuildContext context) {
    final filtered = articles
        .where((a) => a.image != null && a.image.toString().trim().isNotEmpty)
        .toList();
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filtered.length,
        itemBuilder: (_, index) => SizedBox(
          width: 199,
          child: NewsCard(
            item: filtered[index],
            onTap: onArticleClick != null
                ? () => onArticleClick!(filtered[index])
                : null,
          ),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
      ),
    );
  }
}
