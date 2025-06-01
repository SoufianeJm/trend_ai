import 'package:flutter/material.dart';
import 'package:client/features/home/mock/mock_news.dart';
import 'package:client/features/home/view/widgets/news_card.dart';

class NewsCardList extends StatelessWidget {
  const NewsCardList({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 270,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: mockNewsItems.length,
        itemBuilder: (_, index) => NewsCard(item: mockNewsItems[index]),
        separatorBuilder: (_, __) => const SizedBox(width: 16),
      ),
    );
  }
}
