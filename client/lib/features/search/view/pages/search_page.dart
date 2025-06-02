import 'package:flutter/material.dart';
import 'package:client/features/search/view/widgets/search_app_bar.dart';
import 'package:client/features/search/view/widgets/search_widget.dart';

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const SearchAppBar(),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: SearchPageSearchBar(
                controller: _controller,
                onFilterTap: _handleFilterTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
