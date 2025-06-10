import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class ArticleContent extends StatelessWidget {
  final String content;
  const ArticleContent({super.key, required this.content});

  @override
  Widget build(BuildContext context) {
    return Text(
      content,
      style: AppTypography.bodyMedium16.copyWith(color: Palette.gray700),
    );
  }
}
