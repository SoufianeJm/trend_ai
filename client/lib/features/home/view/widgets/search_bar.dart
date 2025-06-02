import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/pages/search_page.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({super.key});

  void _navigateToSearch(BuildContext context) {
    Navigator.of(context).push(_createSearchRoute());
  }

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'search-bar',
      child: GestureDetector(
        onTap: () => _navigateToSearch(context),
        child: Container(
          height: 48,
          padding: const EdgeInsets.symmetric(horizontal: 15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: Palette.gray200),
          ),
          child: Row(
            children: [
              Image.asset('assets/icons/search.png', width: 18, height: 18),
              const SizedBox(width: 8),
              Text(
                "Try ‘Best Moroccan Movie’",
                style: AppTypography.bodyRegular12.copyWith(
                  color: Palette.gray400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Route _createSearchRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) => const SearchPage(),
      transitionsBuilder: (_, animation, __, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeInOut,
          ),
          child: child,
        );
      },
    );
  }
}
