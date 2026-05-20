import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/product_model.dart';
import '../services/discovery_api_service.dart';
import '../widgets/product_card.dart';
import 'filter_sort_screen.dart';
import 'search_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final String title;
  final int? categoryId;
  final List<ProductModel>? initialProducts;

  const ProductListingScreen({
    super.key,
    required this.title,
    this.categoryId,
    this.initialProducts,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  bool isLoading = true;
  bool isGrid = true;
  List<ProductModel> products = [];

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      final result = widget.initialProducts != null
          ? widget.initialProducts!
          : widget.categoryId != null
          ? await service.getProductsByCategory(widget.categoryId!)
          : await service.getProducts();

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
      MaterialPageRoute(
        builder: (_) => FilterSortScreen(categoryId: widget.categoryId),
      ),
    );

    if (filtered != null) setState(() => products = filtered);
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            tooltip: isGrid ? 'List view' : 'Grid view',
            onPressed: () => setState(() => isGrid = !isGrid),
            icon: AnimatedSwitcher(
              duration: const Duration(milliseconds: 220),
              child: Icon(
                isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
                key: ValueKey(isGrid),
              ),
            ),
          ),
          IconButton(
            onPressed: openFilter,
            icon: const Icon(Icons.tune_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchProducts,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: isLoading
              ? const _ProductSkeleton(key: ValueKey('listing-loading'))
              : products.isEmpty
              ? _EmptyProducts(
                  key: const ValueKey('listing-empty'),
                  title: widget.title,
                )
              : CustomScrollView(
                  key: ValueKey('listing-${isGrid ? 'grid' : 'list'}'),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 14, 20, 6),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: theme.dividerColor.withValues(alpha: 0.55),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.inventory_2_rounded,
                                color: AppColors.primary,
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  '${products.length} products found',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.primary.withValues(
                                    alpha: 0.10,
                                  ),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: Text(
                                  isGrid ? 'Grid' : 'List',
                                  style: const TextStyle(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    if (isGrid)
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
                            (context, index) => _AnimatedItem(
                              index: index,
                              child: ProductCard(product: products[index]),
                            ),
                            childCount: products.length,
                          ),
                        ),
                      )
                    else
                      SliverPadding(
                        padding: const EdgeInsets.fromLTRB(20, 14, 20, 110),
                        sliver: SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (context, index) => Padding(
                              padding: EdgeInsets.only(
                                bottom: index == products.length - 1 ? 0 : 14,
                              ),
                              child: _AnimatedItem(
                                index: index,
                                child: SizedBox(
                                  height: 252,
                                  child: ProductCard(product: products[index]),
                                ),
                              ),
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

class _AnimatedItem extends StatelessWidget {
  final int index;
  final Widget child;

  const _AnimatedItem({required this.index, required this.child});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 320 + index * 28),
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

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton({super.key});

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

class _EmptyProducts extends StatelessWidget {
  final String title;

  const _EmptyProducts({super.key, required this.title});

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
          'No products found',
          textAlign: TextAlign.center,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 8),
        Text(
          'Try changing filters for $title.',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}
