import 'package:dewmii/features/discovery/screens/filter_sort_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/product_model.dart';
import '../services/discovery_api_service.dart';
import '../widgets/product_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  bool isLoading = true;
  List<ProductModel> products = [];

  Future<void> search() async {
    setState(() => isLoading = true);

    try {
      final result = await service.searchProducts(widget.query);
      if (!mounted) return;
      setState(() => products = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> openFilter() async {
    final filtered = await Navigator.push<List<ProductModel>>(
      context,
      MaterialPageRoute(builder: (_) => FilterSortScreen(query: widget.query)),
    );

    if (filtered != null) setState(() => products = filtered);
  }

  @override
  void initState() {
    super.initState();
    search();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Results'),
        actions: [
          IconButton(
            onPressed: openFilter,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: search,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: isLoading
              ? const _SearchSkeleton(key: ValueKey('search-loading'))
              : products.isEmpty
              ? _NoResults(
                  key: const ValueKey('search-empty'),
                  query: widget.query,
                )
              : CustomScrollView(
                  key: const ValueKey('search-content'),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: theme.brightness == Brightness.dark
                                ? AppColors.darkHeroGradient
                                : AppColors.heroGradient,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 25,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.search_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '“${widget.query}”',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '${products.length} products found',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 14,
                              mainAxisSpacing: 14,
                              childAspectRatio: 0.68,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (context, index) => _AnimatedSearchItem(
                            index: index,
                            child: ProductCard(product: products[index]),
                          ),
                          childCount: products.length,
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _AnimatedSearchItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedSearchItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 300 + index * 30),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 16 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _SearchSkeleton extends StatelessWidget {
  const _SearchSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 8,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.softMuted,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _NoResults extends StatelessWidget {
  final String query;

  const _NoResults({super.key, required this.query});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 120),
        const Icon(
          Icons.search_off_rounded,
          size: 76,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'No results for “$query”',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Try another keyword or use fewer filters.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
