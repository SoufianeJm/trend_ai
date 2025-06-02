import 'package:flutter/material.dart';

class SearchResultsPage extends StatelessWidget {
  final Map<String, dynamic> data;

  const SearchResultsPage({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Search Results")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Text(
          data.toString(),
          style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
        ),
      ),
    );
  }
}
