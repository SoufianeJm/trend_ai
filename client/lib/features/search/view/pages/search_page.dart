import 'package:flutter/material.dart';
import 'package:client/features/search/view/widgets/search_app_bar.dart';
import 'package:client/features/search/view/widgets/search_widget.dart';
import 'package:client/features/search/view/widgets/recent_search_section.dart';
import 'package:client/features/search/view/widgets/popular_tags_section.dart';
import 'package:client/features/search/view/widgets/trending_section.dart';


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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView( // Enables scrolling when needed
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                const SearchAppBar(),
                const SizedBox(height: 16),
                SearchPageSearchBar(
                  controller: _controller,
                  onFilterTap: _handleFilterTap,
                ),
                const SizedBox(height: 24),
                const RecentSearchSection(),
                const PopularTagsSection(),
                const SizedBox(height: 24),
                const TrendingSection(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
