import 'package:flutter/material.dart';
import 'package:client/features/search/view/widgets/search_app_bar.dart';
import 'package:client/features/search/view/widgets/search_widget.dart';
import 'package:client/features/search/view/widgets/category_chips_bar.dart';
import 'package:client/core/theme/app_palette.dart';
import 'package:client/core/theme/typography.dart';
import 'package:client/features/search/service/search_service.dart';
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
  final bottomInset = MediaQuery.of(context).viewInsets.bottom;

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
                  'For best accuracy choose a category',
                  style: AppTypography.bodyRegular12.copyWith(color: Palette.gray400),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    ),
    bottomNavigationBar: AnimatedPadding(
      duration: const Duration(milliseconds: 200),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: bottomInset > 0 ? bottomInset : 24),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 24),
        child: CategoryChipsBar(),
      ),
    ),
  );
}

}
