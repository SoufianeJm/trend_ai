import 'package:flutter/material.dart';
import 'package:client/features/search/view/widgets/search_app_bar.dart';
import 'package:client/features/search/view/widgets/search_widget.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/view/pages/search_results_page.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _handleFilterTap() {
    // TODO: Implement filter logic
  }

  Future<void> _handleSearch(String value) async {
    final query = value.trim();
    if (query.isEmpty) return;

    // Navigate to results page with basic data
    if (!mounted) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SearchResultsPage(
          data: {
            'query': query,
            'results': [], // Empty results for now
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const SearchAppBar(),
                const SizedBox(height: 16),
                SearchPageSearchBar(
                  controller: _controller,
                  onFilterTap: _handleFilterTap,
                  onSubmitted: _handleSearch,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Text(
                    'Search results may not always be accurate',
                    style: AppTypography.bodyRegular12.copyWith(
                      color: Palette.gray400,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
