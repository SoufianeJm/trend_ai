import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onViewMore;

  const SectionHeader({
    super.key,
    required this.title,
    this.onViewMore,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: AppTypography.bodyMedium18.copyWith(color: Palette.gray900),
        ),
        const Spacer(),
        GestureDetector(
          onTap: onViewMore,
          child: Text(
            'View More',
            style: AppTypography.bodyRegular12.copyWith(color: Palette.gray900),
          ),
        ),
      ],
    );
  }
}
