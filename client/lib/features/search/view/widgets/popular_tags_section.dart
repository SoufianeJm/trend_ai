import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class PopularTagsSection extends StatelessWidget {
  const PopularTagsSection({super.key});

  static const tags = [
    '#business',
    '#education',
    '#technology',
    '#sport',
    '#morocco',
    '#politics',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Tags',
          style: AppTypography.bodyMedium16.copyWith(
            color: Palette.gray900,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                border: Border.all(color: Palette.gray200),
              ),
              child: Text(
                tag,
                style: AppTypography.bodyRegular14.copyWith(
                  color: Palette.gray900,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
