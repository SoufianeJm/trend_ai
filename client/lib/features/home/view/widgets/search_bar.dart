import 'package:flutter/material.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/pages/search_results_page.dart';
import 'package:client/features/search/service/search_service.dart';

class SearchBar extends StatefulWidget {
  const SearchBar({super.key});

  @override
  State<SearchBar> createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  final TextEditingController _controller = TextEditingController();

  Future<void> _handleSubmit() async {
    final query = _controller.text.trim();
    if (query.isEmpty) return;

    try {
      final result = await SearchService.search(query);
      if (!mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => SearchResultsPage(data: result),
        ),
      );
    } catch (e) {
      debugPrint('❌ Search error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // 🔍 Search input
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 15),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Palette.gray200, width: 1),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/icons/search.png',
                  width: 18,
                  height: 18,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    onSubmitted: (_) => _handleSubmit(),
                    style: AppTypography.bodyRegular12.copyWith(
                      color: Palette.gray900,
                    ),
                    decoration: InputDecoration(
                      hintText: "Try ‘Best Moroccan Movie’",
                      hintStyle: AppTypography.bodyRegular12.copyWith(
                        color: Palette.gray400,
                      ),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),

        const SizedBox(width: 8),

        // ✅ Submit button
        GestureDetector(
          onTap: _handleSubmit,
          child: Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Palette.gray200, width: 1),
            ),
            child: Center(
              child: Image.asset(
                'assets/icons/submit.png', // Update with your icon
                width: 18,
                height: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
