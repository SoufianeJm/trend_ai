import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/pages/search_results_page.dart';

class PopularTagsSection extends StatelessWidget {
  const PopularTagsSection({super.key});

  static const List<String> queries = [
    'Morocco latest news',
    'Botola results',
    'Weather today',
    'Royal family',
    'Africa Cup of Nations',
    'Casablanca events',
    'Dirham exchange rate',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'People also search',
          style: AppTypography.bodyMedium18.copyWith(
            color: Palette.gray900,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: queries.map((query) {
            return GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => SearchResultsPage(
                      data: {
                        'query': query,
                        'results': [],
                      },
                    ),
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(color: Palette.gray200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  query,
                  style: AppTypography.bodyRegular12.copyWith(
                    color: Palette.gray900,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
