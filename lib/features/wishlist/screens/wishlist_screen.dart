import 'package:dewmii/shared/widgets/navigation/common_app_header.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../product/screens/product_details_screen.dart';
import '../models/wishlist_item_model.dart';
import '../services/wishlist_api_service.dart';
import '../widgets/wishlist_item_card.dart';

class WishlistScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const WishlistScreen({super.key, this.showCommonScaffold = true});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistApiService service = WishlistApiService();

  bool isLoading = true;
  bool isActionLoading = false;

  List<WishlistItemModel> items = [];
  int wishlistCount = 0;

  Future<void> fetchWishlist() async {
    if (!mounted) return;

    setState(() => isLoading = true);

    try {
      final result = await service.getWishlist();

      if (!mounted) return;

      setState(() {
        items = result;
        wishlistCount = result.length;
      });
    } catch (error) {
      if (!mounted) return;
      _showError(error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> removeItem(WishlistItemModel item) async {
    final confirmed = await _confirmRemove(item);
    if (!confirmed || !mounted) return;

    await _runAction(() async {
      final response = await service.removeFromWishlist(productId: item.productId);
      final removedProductId =
          service.parseRemovedProductId(response) ?? item.productId;

      setState(() {
        items = items
            .where((wishlistItem) => wishlistItem.productId != removedProductId)
            .toList();
        wishlistCount = service.parseWishlistCount(response) ?? items.length;
      });

      _showSuccess(response['message'] ?? 'Product removed from wishlist');
    });
  }

  Future<void> moveToCart(WishlistItemModel item) async {
    await _runAction(() async {
      final response = await service.moveToCart(productId: item.productId);

      setState(() {
        items = items
            .where((wishlistItem) => wishlistItem.productId != item.productId)
            .toList();
        wishlistCount = service.parseWishlistCount(response) ?? items.length;
      });

      _showSuccess(response['message'] ?? 'Product moved to cart successfully');
    });
  }

  Future<void> addDemoProduct() async {
    await _runAction(() async {
      final response = await service.addToWishlist(productId: 101);
      final addedItem = service.parseAddedWishlistItem(response);

      setState(() {
        if (addedItem != null) {
          final alreadyExists = items.any(
            (item) => item.productId == addedItem.productId,
          );

          if (!alreadyExists) {
            items = [addedItem, ...items];
          }
        }

        wishlistCount = service.parseWishlistCount(response) ?? items.length;
      });

      _showSuccess(response['message'] ?? 'Product added to wishlist');
    });
  }

  Future<void> _runAction(Future<void> Function() action) async {
    if (isActionLoading) return;

    setState(() => isActionLoading = true);

    try {
      await action();
    } catch (error) {
      if (!mounted) return;
      _showError(error);
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<bool> _confirmRemove(WishlistItemModel item) async {
    final result = await showModalBottomSheet<bool>(
      context: context,
      useSafeArea: true,
      showDragHandle: true,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  color: AppColors.danger,
                  size: 30,
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Remove from wishlist?',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w900,
                    ),
              ),
              const SizedBox(height: 8),
              Text(
                item.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.70),
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Keep'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Remove'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    return result ?? false;
  }

  void openProductDetails(WishlistItemModel item) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) {
          return FadeTransition(
            opacity: animation,
            child: ProductDetailsScreen(productId: item.productId),
          );
        },
      ),
    );
  }

  void _showSuccess(Object? message) {
    AppToast.show(
      context,
      message: message?.toString() ?? 'Success',
      type: ToastType.success,
    );
  }

  void _showError(Object error) {
    AppToast.show(
      context,
      message: error.toString().replaceAll('Exception: ', ''),
      type: ToastType.error,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppHeader(
        title: 'Wishlist',
        showBackButton: widget.showCommonScaffold,
        actions: [
          IconButton(
            tooltip: 'Add demo product',
            onPressed: isActionLoading ? null : addDemoProduct,
            icon: const Icon(Icons.favorite_rounded),
          ),
        ],
      ),
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: fetchWishlist,
            child: CustomScrollView(
              physics: const AlwaysScrollableScrollPhysics(
                parent: BouncingScrollPhysics(),
              ),
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                  sliver: SliverToBoxAdapter(
                    child: _WishlistHero(
                      count: wishlistCount,
                      totalValue: _wishlistValue,
                      isLoading: isLoading,
                    ),
                  ),
                ),
                if (isLoading)
                  const SliverPadding(
                    padding: EdgeInsets.fromLTRB(20, 18, 20, 40),
                    sliver: SliverToBoxAdapter(child: _WishlistSkeletonList()),
                  )
                else if (items.isEmpty)
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: _EmptyWishlist(onAddDemoProduct: addDemoProduct),
                  )
                else ...[
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
                    sliver: SliverToBoxAdapter(
                      child: _SectionTitle(count: items.length),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 0, 20, 40),
                    sliver: SliverList.separated(
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const SizedBox(height: 14),
                      itemBuilder: (context, index) {
                        final item = items[index];

                        return WishlistItemCard(
                          item: item,
                          onTap: () => openProductDetails(item),
                          onRemove: isActionLoading ? () {} : () => removeItem(item),
                          onMoveToCart:
                              isActionLoading ? () {} : () => moveToCart(item),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isActionLoading)
            Positioned(
              left: 0,
              top: 0,
              right: 0,
              child: LinearProgressIndicator(
                minHeight: 3,
                backgroundColor: AppColors.primary.withValues(alpha: 0.08),
              ),
            ),
        ],
      ),
    );
  }

  num get _wishlistValue {
    return items.fold<num>(0, (sum, item) {
      final price = item.hasDiscount ? item.discountPrice : item.price;
      return sum + price;
    });
  }
}

class _WishlistHero extends StatelessWidget {
  final int count;
  final num totalValue;
  final bool isLoading;

  const _WishlistHero({
    required this.count,
    required this.totalValue,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 520),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.scale(
          scale: 0.96 + (0.04 * value),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF4D7D), Color(0xFFFF8A5C)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFF4D7D).withValues(alpha: 0.24),
              blurRadius: 28,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -22,
              child: Icon(
                Icons.favorite_rounded,
                size: 132,
                color: Colors.white.withValues(alpha: 0.10),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.favorite_rounded,
                  color: Colors.white.withValues(alpha: 0.96),
                  size: 34,
                ),
                const SizedBox(height: 16),
                Text(
                  isLoading ? 'Loading saved picks...' : '$count saved items',
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Keep your favorite products ready for checkout.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: Colors.white.withValues(alpha: 0.82),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 18),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _HeroMetric(
                      icon: Icons.shopping_bag_rounded,
                      label: 'Products',
                      value: '$count',
                    ),
                    _HeroMetric(
                      icon: Icons.payments_rounded,
                      label: 'Value',
                      value: '৳$totalValue',
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _HeroMetric({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.20)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 17),
          const SizedBox(width: 7),
          Text(
            '$label: ',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.76),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final int count;

  const _SectionTitle({required this.count});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          'Saved Favorites',
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w900,
              ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            '$count',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }
}

class _EmptyWishlist extends StatelessWidget {
  final VoidCallback onAddDemoProduct;

  const _EmptyWishlist({required this.onAddDemoProduct});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(28),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 700),
            curve: Curves.elasticOut,
            tween: Tween(begin: 0.7, end: 1),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: 118,
              height: 118,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.favorite_border_rounded,
                size: 60,
                color: AppColors.primary,
              ),
            ),
          ),
          const SizedBox(height: 22),
          Text(
            'Your wishlist is empty',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the heart icon on any product and it will appear here for quick access later.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context)
                      .textTheme
                      .bodyMedium
                      ?.color
                      ?.withValues(alpha: 0.64),
                  height: 1.45,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: onAddDemoProduct,
            icon: const Icon(Icons.favorite_rounded),
            label: const Text('Add Demo Product'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WishlistSkeletonList extends StatelessWidget {
  const _WishlistSkeletonList();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
        4,
        (index) => Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: _SkeletonCard(delay: index * 90),
        ),
      ),
    );
  }
}

class _SkeletonCard extends StatelessWidget {
  final int delay;

  const _SkeletonCard({required this.delay});

  @override
  Widget build(BuildContext context) {
    final baseColor = Theme.of(context).brightness == Brightness.dark
        ? Colors.white.withValues(alpha: 0.07)
        : Colors.black.withValues(alpha: 0.06);

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 750 + delay),
      curve: Curves.easeInOut,
      tween: Tween(begin: 0.45, end: 1),
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: baseColor,
          borderRadius: BorderRadius.circular(26),
        ),
        child: Row(
          children: [
            Container(
              width: 104,
              height: 126,
              decoration: BoxDecoration(
                color: baseColor,
                borderRadius: BorderRadius.circular(22),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                children: [
                  _SkeletonLine(widthFactor: 1, color: baseColor),
                  const SizedBox(height: 10),
                  _SkeletonLine(widthFactor: .72, color: baseColor),
                  const SizedBox(height: 18),
                  _SkeletonLine(widthFactor: .44, color: baseColor),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Container(
                        height: 44,
                        width: 44,
                        decoration: BoxDecoration(
                          color: baseColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Container(
                          height: 44,
                          decoration: BoxDecoration(
                            color: baseColor,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SkeletonLine extends StatelessWidget {
  final double widthFactor;
  final Color color;

  const _SkeletonLine({
    required this.widthFactor,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      alignment: Alignment.centerLeft,
      widthFactor: widthFactor,
      child: Container(
        height: 13,
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(999),
        ),
      ),
    );
  }
}
