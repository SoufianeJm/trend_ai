import 'package:flutter/material.dart';

class ArticleImage extends StatelessWidget {
  const ArticleImage({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: Image.asset(
        'assets/images/article_detail.png',
        width: double.infinity,
        height: 260,
        fit: BoxFit.cover,
      ),
    );
  }
}
