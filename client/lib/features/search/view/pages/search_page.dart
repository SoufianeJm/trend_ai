import 'package:client/features/search/service/search_service.dart';
import 'package:client/features/search/view/pages/search_results_page.dart';

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _controller = TextEditingController();

  void _handleFilterTap() {
    // TODO: Implement filter logic
  }

  Future<void> _handleSearch(String value) async {
    final query = value.trim();
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
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
                  onSubmitted: _handleSearch,
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
