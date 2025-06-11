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
        Text(article.categorieLabel, style: AppTypography.bodyMedium14.copyWith(color: Palette.primary)),
        const SizedBox(width: 12),
        Text(timeAgoFromNow(article.publishedAt), style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400)),
        const Spacer(),
        Icon(Icons.thumb_up_alt_outlined, size: 18, color: Palette.gray400),
        const SizedBox(width: 4),
        Text('2k liked', style: AppTypography.bodyMedium14.copyWith(color: Palette.gray400)),
      ],
    );
  }
}
