import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class ArticleTitle extends StatelessWidget {
  final String title;
  const ArticleTitle({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: AppTypography.h5.copyWith(color: Palette.gray900),
      ),
    );
  }
}
