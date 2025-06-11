import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';

class ArticleContent extends StatelessWidget {
  final String content;
  const ArticleContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Html(data: content);
  }
}
