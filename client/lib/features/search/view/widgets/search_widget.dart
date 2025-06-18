import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';

class SearchPageSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final VoidCallback onFilterTap;
  final Function(String)? onSubmitted;

  const SearchPageSearchBar({
    super.key,
    required this.controller,
    required this.onFilterTap,
    this.onSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Palette.gray200, width: 1),
      ),
      child: Row(
        children: [
          Image.asset(
            'assets/icons/search.png',
            width: 20,
            height: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: TextField(
              controller: controller,
              autofocus: true,
              onSubmitted: onSubmitted,
              style: AppTypography.bodyMedium14.copyWith(color: Palette.gray900),
              decoration: InputDecoration(
                isDense: true,
                hintText: "Search article...",
                hintStyle: AppTypography.bodyMedium14.copyWith(
                  color: Palette.gray400,
                ),
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onFilterTap,
            child: Image.asset(
              'assets/icons/filter.png',
              width: 20,
              height: 20,
            ),
          ),
        ],
      ),
    );
  }
}
