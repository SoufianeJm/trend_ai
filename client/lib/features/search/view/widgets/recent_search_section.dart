import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/data/recent_search_mock.dart';

class RecentSearchSection extends StatelessWidget {
  const RecentSearchSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Search',
          style: AppTypography.bodyMedium16.copyWith(
            color: Palette.gray900,
          ),
        ),
        const SizedBox(height: 16),
        ...recentSearches.map(
          (term) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    term,
                    style: AppTypography.bodyRegular14.copyWith(
                      color: Palette.gray500,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Image.asset(
                  'assets/icons/close.png', // Replace this with your actual close icon
                  width: 18,
                  height: 18,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
