import 'package:flutter/material.dart';

import 'package:client/features/home/data/models/article_model.dart';

const _imageBaseUrl = 'https://cdn.snrtbotola.ma';

class ArticleImage extends StatelessWidget {
  final Article article;
  const ArticleImage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      child: article.image.trim().isNotEmpty
          ? Image.network(
              '$_imageBaseUrl${article.image}',
              width: double.infinity,
              height: 260,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                width: double.infinity,
                height: 260,
                color: Colors.grey[300],
                child: const Icon(Icons.broken_image),
              ),
            )
          : Container(
              width: double.infinity,
              height: 260,
              color: Colors.grey[300],
              child: const Icon(Icons.broken_image),
            ),
    );
  }
}
