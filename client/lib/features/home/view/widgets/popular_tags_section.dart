import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class PopularTagsSection extends StatelessWidget {
  final List<String> tags;

  const PopularTagsSection({
    super.key,
    required this.tags,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Popular Tags',
          style: AppTypography.bodyMedium18.copyWith(
            color: Palette.gray900,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tags.map((tag) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: Palette.gray200),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                tag,
                style: AppTypography.bodyRegular12.copyWith(
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
