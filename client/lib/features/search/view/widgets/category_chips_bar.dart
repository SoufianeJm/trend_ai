import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class CategoryChipsBar extends StatelessWidget {
  const CategoryChipsBar({super.key});

  static const _categories = ['Auto', 'News', 'Sports', 'Movies', 'Schedule'];
  final String _selected = 'Auto'; // Static for now

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: _categories.map((category) {
          final isSelected = category == _selected;

          return Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              decoration: BoxDecoration(
                color: isSelected ? Palette.primary : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? Colors.transparent : Palette.gray200,
                  width: 1,
                ),
              ),
              child: Text(
                category,
                style: AppTypography.bodyMedium12.copyWith(
                  color: isSelected ? Palette.white : Palette.gray400,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
