import 'package:dewmii/features/discovery/screens/search_result_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final searchController = TextEditingController();

  final List<String> popularSearches = [
    'T-Shirt',
    'Shoes',
    'Watch',
    'Wallet',
    'Electronics',
    'Fashion',
  ];

  void submitSearch(String value) {
    final query = value.trim();

    if (query.isEmpty) return;

    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => SearchResultScreen(query: query)),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextField(
            controller: searchController,
            autofocus: true,
            textInputAction: TextInputAction.search,
            onSubmitted: submitSearch,
            decoration: InputDecoration(
              hintText: 'Search products...',
              prefixIcon: const Icon(Icons.search_rounded),
              suffixIcon: IconButton(
                onPressed: () {
                  searchController.clear();
                },
                icon: const Icon(Icons.close_rounded),
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Popular Searches',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: popularSearches.map((item) {
              return ActionChip(
                label: Text(item),
                backgroundColor: AppColors.softMuted,
                side: const BorderSide(color: AppColors.lightBorder),
                onPressed: () {
                  searchController.text = item;
                  submitSearch(item);
                },
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
