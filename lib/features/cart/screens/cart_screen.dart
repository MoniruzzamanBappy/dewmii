import 'package:dewmii/features/checkout/screens/checkout_screen.dart';
import 'package:dewmii/shared/widgets/navigation/common_app_header.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/cart_coupon_model.dart';
import '../models/cart_item_model.dart';
import '../models/cart_model.dart';
import '../models/cart_summary_model.dart';
import '../services/cart_api_service.dart';
import '../widgets/apply_coupon_section.dart';
import '../widgets/cart_item_card.dart';
import '../widgets/cart_summary_section.dart';

class CartScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const CartScreen({super.key, this.showCommonScaffold = true});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> with TickerProviderStateMixin {
  final CartApiService service = CartApiService();

  bool isLoading = true;
  bool isActionLoading = false;
  CartModel cart = CartModel.empty();

  Future<void> fetchCart() async {
    if (!mounted) return;
    setState(() => isLoading = true);

    try {
      final result = await service.getCart();
      if (!mounted) return;
      setState(() => cart = result);
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    if (quantity < 1 || isActionLoading) return;

    setState(() => isActionLoading = true);

    try {
      final response = await service.updateItemQuantityDemo(
        cartItemId: item.id,
        quantity: quantity,
      );

      final updatedItem = service.parseUpdatedCartItem(response);
      final updatedSummary = service.parseSummary(response);

      if (!mounted) return;
      setState(() {
        final updatedItems = cart.items.map((cartItem) {
          if (cartItem.id != item.id) return cartItem;
          return updatedItem ??
              cartItem.copyWith(
                quantity: quantity,
                subtotal: cartItem.price * quantity,
              );
        }).toList();

        cart = cart.copyWith(
          items: updatedItems,
          summary: updatedSummary ?? _summaryFromItems(updatedItems),
        );
      });

      _showSuccess(response['message'] ?? 'Cart item updated successfully');
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> removeItem(CartItemModel item) async {
    if (isActionLoading) return;

    setState(() => isActionLoading = true);

    try {
      final response = await service.removeItemDemo(cartItemId: item.id);
      final updatedSummary = service.parseSummary(response);

      if (!mounted) return;
      setState(() {
        final updatedItems = cart.items
            .where((cartItem) => cartItem.id != item.id)
            .toList();
        cart = cart.copyWith(
          items: updatedItems,
          summary: updatedSummary ?? _summaryFromItems(updatedItems),
        );
      });

      _showSuccess(response['message'] ?? 'Cart item removed successfully');
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> applyCoupon(String couponCode) async {
    if (couponCode.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please enter a coupon code',
        type: ToastType.warning,
      );
      return;
    }

    setState(() => isActionLoading = true);

    try {
      final response = await service.applyCouponDemo(
        couponCode: couponCode.trim(),
      );
      final data = response['data'];

      if (data is! Map) {
        _showSuccess(response['message'] ?? 'Coupon applied successfully');
        return;
      }

      final couponJson = data['coupon'];
      final summaryJson = data['summary'];
      final coupon = couponJson is Map
          ? CartCouponModel.fromJson(Map<String, dynamic>.from(couponJson))
          : cart.coupon;
      final summary = summaryJson is Map
          ? CartSummaryModel.fromJson(Map<String, dynamic>.from(summaryJson))
          : cart.summary;

      if (!mounted) return;
      setState(() => cart = cart.copyWith(coupon: coupon, summary: summary));

      _showSuccess(response['message'] ?? 'Coupon applied successfully');
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> removeCoupon() async {
    if (isActionLoading) return;

    setState(() => isActionLoading = true);

    try {
      final response = await service.removeCouponDemo();
      final updatedSummary = service.parseSummary(response);

      if (!mounted) return;
      setState(() {
        cart = cart.copyWith(
          clearCoupon: true,
          summary:
              updatedSummary ??
              cart.summary.copyWith(discount: 0, clearCouponCode: true),
        );
      });

      _showSuccess(response['message'] ?? 'Coupon removed successfully');
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> clearCart() async {
    if (isActionLoading || cart.items.isEmpty) return;

    final shouldClear = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 6, 22, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Icon(
                      Icons.delete_sweep_outlined,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Clear cart?',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'All items and the applied coupon will be removed from your cart.',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 22),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.error,
                      ),
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Clear'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (shouldClear != true || !mounted) return;

    setState(() => isActionLoading = true);

    try {
      final result = await service.clearCartDemo();
      if (!mounted) return;
      setState(() => cart = result);
      _showSuccess('Cart cleared successfully');
    } catch (error) {
      _showError(error);
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  void checkoutDemo() {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => const CheckoutScreen(),
        transitionsBuilder: (_, animation, _, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchCart();
  }

  @override
  Widget build(BuildContext context) {
    final items = cart.items;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark
          ? AppColors.darkBackground
          : AppColors.lightBackground,
      appBar: CommonAppHeader(
        title: 'My Cart',
        showBackButton: widget.showCommonScaffold,
        actions: [
          if (items.isNotEmpty)
            TextButton.icon(
              onPressed: isActionLoading ? null : clearCart,
              icon: const Icon(Icons.delete_sweep_outlined, size: 18),
              label: const Text('Clear'),
            ),
        ],
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 280),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: isLoading
            ? const _CartSkeleton(key: ValueKey('cart-loading'))
            : RefreshIndicator(
                key: const ValueKey('cart-content'),
                onRefresh: fetchCart,
                child: items.isEmpty
                    ? const _EmptyCartView()
                    : CustomScrollView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        slivers: [
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                            sliver: SliverToBoxAdapter(
                              child: _CartHero(
                                totalItems: cart.summary.totalItems,
                                total: cart.summary.total,
                                isActionLoading: isActionLoading,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                            sliver: SliverList.separated(
                              itemCount: items.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(height: 14),
                              itemBuilder: (context, index) {
                                final item = items[index];
                                return TweenAnimationBuilder<double>(
                                  duration: Duration(
                                    milliseconds:
                                        260 + (index * 40).clamp(0, 220),
                                  ),
                                  tween: Tween(begin: 0, end: 1),
                                  curve: Curves.easeOutCubic,
                                  builder: (context, value, child) {
                                    return Opacity(
                                      opacity: value,
                                      child: Transform.translate(
                                        offset: Offset(0, 18 * (1 - value)),
                                        child: child,
                                      ),
                                    );
                                  },
                                  child: CartItemCard(
                                    item: item,
                                    isLoading: isActionLoading,
                                    onIncrease: () =>
                                        updateQuantity(item, item.quantity + 1),
                                    onDecrease: () =>
                                        updateQuantity(item, item.quantity - 1),
                                    onRemove: () => removeItem(item),
                                  ),
                                );
                              },
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 0),
                            sliver: SliverToBoxAdapter(
                              child: ApplyCouponSection(
                                coupon: cart.coupon,
                                isLoading: isActionLoading,
                                onApplyCoupon: applyCoupon,
                                onRemoveCoupon: removeCoupon,
                              ),
                            ),
                          ),
                          SliverPadding(
                            padding: const EdgeInsets.fromLTRB(20, 18, 20, 38),
                            sliver: SliverToBoxAdapter(
                              child: CartSummarySection(
                                summary: cart.summary,
                                isLoading: isActionLoading,
                                onCheckout: checkoutDemo,
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
      ),
    );
  }

  CartSummaryModel _summaryFromItems(List<CartItemModel> items) {
    final subtotal = items.fold<num>(
      0,
      (sum, item) => sum + item.effectiveSubtotal,
    );
    final totalItems = items.fold<int>(0, (sum, item) => sum + item.quantity);
    final discount = cart.coupon == null ? 0 : cart.summary.discount;
    final shipping = items.isEmpty ? 0 : cart.summary.shippingCharge;
    final tax = items.isEmpty ? 0 : cart.summary.tax;

    return cart.summary.copyWith(
      subtotal: subtotal,
      totalItems: totalItems,
      discount: discount,
      shippingCharge: shipping,
      tax: tax,
      total: subtotal - discount + shipping + tax,
    );
  }

  void _showError(Object error) {
    if (!mounted) return;
    AppToast.show(
      context,
      message: error.toString().replaceAll('Exception: ', ''),
      type: ToastType.error,
    );
  }

  void _showSuccess(dynamic message) {
    if (!mounted) return;
    AppToast.show(
      context,
      message: message?.toString() ?? 'Done',
      type: ToastType.success,
    );
  }
}

class _CartHero extends StatelessWidget {
  final int totalItems;
  final num total;
  final bool isActionLoading;

  const _CartHero({
    required this.totalItems,
    required this.total,
    required this.isActionLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkHeroGradient
            : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.14),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.26),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.shopping_bag_outlined,
                  color: Colors.white,
                  size: 28,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.20),
                  ),
                ),
                child: Text(
                  '$totalItems items',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Ready to checkout?',
            style: TextStyle(
              color: Colors.white,
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Cart total ৳${_money(total)}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.88),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            height: isActionLoading ? 18 : 0,
            alignment: Alignment.bottomCenter,
            child: isActionLoading
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(999),
                    child: LinearProgressIndicator(
                      minHeight: 4,
                      backgroundColor: Colors.white.withValues(alpha: 0.22),
                      color: Colors.white,
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  String _money(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}

class _EmptyCartView extends StatelessWidget {
  const _EmptyCartView();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(24, 88, 24, 24),
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 520),
          tween: Tween(begin: 0, end: 1),
          curve: Curves.easeOutBack,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            width: 132,
            height: 132,
            margin: const EdgeInsets.symmetric(horizontal: 78),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(42),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.22),
                  blurRadius: 30,
                  offset: const Offset(0, 18),
                ),
              ],
            ),
            child: const Icon(
              Icons.shopping_cart_outlined,
              size: 64,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 28),
        Text(
          'Your cart is empty',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: textPrimary,
            fontSize: 25,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          'Add your favorite products and they will appear here for quick checkout.',
          textAlign: TextAlign.center,
          style: TextStyle(color: textSecondary, height: 1.5),
        ),
      ],
    );
  }
}

class _CartSkeleton extends StatelessWidget {
  const _CartSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final base = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final highlight = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.softMuted;

    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        final height = index == 0 ? 132.0 : 142.0;
        return TweenAnimationBuilder<double>(
          duration: Duration(milliseconds: 650 + index * 80),
          tween: Tween(begin: 0.35, end: 1),
          curve: Curves.easeInOut,
          builder: (context, value, child) {
            return Opacity(opacity: value, child: child);
          },
          child: Container(
            height: height,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [base, highlight, base],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(26),
            ),
          ),
        );
      },
    );
  }
}
