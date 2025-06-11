import 'package:flutter/material.dart';
import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/features/home/view/widgets/news_card.dart';
import 'package:client/features/home/data/models/article_model.dart';

class NewsCardList extends StatelessWidget {
  final List<Article> articles;
  const NewsCardList({super.key, required this.articles});

  @override
  Widget build(BuildContext context) {
    final filtered = articles.where((a) => a.image != null && a.image.toString().trim().isNotEmpty).toList();
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: filtered.length,
        itemBuilder: (_, index) => SizedBox(
          width: 199,
          child: NewsCard(item: filtered[index]),
        ),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
      ),
    );
  }
}
