import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/home/view/pages/home_page.dart';

class SearchAppBar extends StatelessWidget {
  const SearchAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 40,
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const HomePage()),
                  (route) => false,
                );
              },
              child: Image.asset(
                'assets/icons/back.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
          Center(
            child: Text(
              'Search',
              style: AppTypography.bodyMedium18.copyWith(
                color: Palette.gray900,
              ),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: GestureDetector(
              onTap: () {
                // TODO: Open menu or search settings
              },
              child: Image.asset(
                'assets/icons/more1.png',
                width: 24,
                height: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
