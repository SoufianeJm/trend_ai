import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

import 'package:client/features/home/data/models/article_model.dart';
import 'package:client/utils/date_utils.dart';

class MetaRow extends StatelessWidget {
  final Article article;
  const MetaRow({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(article.categorieLabel ?? 'Unknown', style: AppTypography.bodyMedium14.copyWith(color: Palette.primary)),
        const SizedBox(width: 12),
        Text(timeAgoFromNow(article.publishedAt ?? DateTime.now()), style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400)),
      ],
    );
  }
}
