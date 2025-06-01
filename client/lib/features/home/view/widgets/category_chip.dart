import 'package:flutter/material.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/core/theme/app_palette.dart';

class CategoryChip extends StatelessWidget {
  final String label;
  final String assetPath;

  const CategoryChip({
    super.key,
    required this.label,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerSize = screenWidth * 0.10; // 10% of screen width

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: containerSize,
          height: containerSize,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(
              color: Palette.gray200,
              width: 1,
            ),
          ),
          child: Center(
            child: Image.asset(
              assetPath,
              width: containerSize * 0.5,
              height: containerSize * 0.5,
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: AppTypography.bodyMedium10.copyWith(
            color: Palette.gray900,
          ),
        ),
      ],
    );
  }
}
