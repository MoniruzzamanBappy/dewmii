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

  final List<String> popularSearches = const [
    'T-Shirt',
    'Shoes',
    'Watch',
    'Wallet',
    'Electronics',
    'Fashion',
  ];

  final List<String> recentSearches = const [
    'Summer outfit',
    'Smart watch',
    'Sneakers',
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
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Search')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: theme.brightness == Brightness.dark
                  ? AppColors.darkHeroGradient
                  : AppColors.heroGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are you looking for?',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.6,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Search products, categories, brands, and deals.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: searchController,
                  autofocus: true,
                  textInputAction: TextInputAction.search,
                  onSubmitted: submitSearch,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    prefixIcon: const Icon(Icons.search_rounded),
                    suffixIcon: AnimatedBuilder(
                      animation: searchController,
                      builder: (context, _) {
                        return searchController.text.isEmpty
                            ? const SizedBox.shrink()
                            : IconButton(
                                onPressed: () => searchController.clear(),
                                icon: const Icon(Icons.close_rounded),
                              );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          _SearchSection(
            title: 'Popular Searches',
            icon: Icons.local_fire_department_rounded,
            children: popularSearches.map((item) {
              return _SearchChip(
                label: item,
                onTap: () {
                  searchController.text = item;
                  submitSearch(item);
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 22),
          _SearchSection(
            title: 'Recent Ideas',
            icon: Icons.history_rounded,
            children: recentSearches.map((item) {
              return _SearchChip(
                label: item,
                icon: Icons.north_west_rounded,
                onTap: () {
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

class _SearchSection extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Widget> children;

  const _SearchSection({
    required this.title,
    required this.icon,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 10),
              Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Wrap(spacing: 10, runSpacing: 10, children: children),
        ],
      ),
    );
  }
}

class _SearchChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _SearchChip({
    required this.label,
    required this.onTap,
    this.icon = Icons.search_rounded,
  });

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 17, color: AppColors.primary),
      label: Text(label),
      onPressed: onTap,
      backgroundColor: AppColors.primary.withValues(alpha: 0.08),
      side: BorderSide(color: AppColors.primary.withValues(alpha: 0.12)),
      labelStyle: const TextStyle(fontWeight: FontWeight.w800),
    );
  }
}
