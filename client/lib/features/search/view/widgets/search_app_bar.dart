import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Image.asset(
              'assets/icons/back.png', // 👈 Replace with your actual icon
              width: 24,
              height: 24,
            ),
          ),
          const Spacer(),
          Text(
            'Search',
            style: AppTypography.bodyMedium18.copyWith(
              color: Palette.gray900,
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () {
              // TODO: Open search settings menu
            },
            child: Image.asset(
              'assets/icons/more1.png', // 👈 Replace with your actual icon
              width: 24,
              height: 24,
            ),
          ),
        ],
      ),
    );
  }
}
