import 'package:dewmii/features/checkout/screens/checkout_screen.dart';
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
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final CartApiService service = CartApiService();

  bool isLoading = true;
  bool isActionLoading = false;

  CartModel cart = CartModel.empty();

  Future<void> fetchCart() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getCart();

      if (!mounted) return;

      setState(() {
        cart = result;
      });
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> updateQuantity(CartItemModel item, int quantity) async {
    setState(() {
      isActionLoading = true;
    });

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
          if (cartItem.id == item.id && updatedItem != null) {
            return updatedItem;
          }

          if (cartItem.id == item.id) {
            return cartItem.copyWith(
              quantity: quantity,
              subtotal: cartItem.price * quantity,
            );
          }

          return cartItem;
        }).toList();

        cart = cart.copyWith(items: updatedItems, summary: updatedSummary);
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Cart item updated successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> removeItem(CartItemModel item) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.removeItemDemo(cartItemId: item.id);

      final updatedSummary = service.parseSummary(response);

      if (!mounted) return;

      setState(() {
        final updatedItems = cart.items.where((cartItem) {
          return cartItem.id != item.id;
        }).toList();

        cart = cart.copyWith(items: updatedItems, summary: updatedSummary);
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Cart item removed successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> applyCoupon(String couponCode) async {
    if (couponCode.isEmpty) {
      AppToast.show(
        context,
        message: 'Please enter a coupon code',
        type: ToastType.warning,
      );
      return;
    }

    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.applyCouponDemo(couponCode: couponCode);

      final data = response['data'];

      if (data is! Map<String, dynamic>) return;

      final couponJson = data['coupon'];
      final summaryJson = data['summary'];

      final coupon = couponJson is Map<String, dynamic>
          ? CartCouponModel.fromJson(couponJson)
          : null;

      final summary = summaryJson is Map<String, dynamic>
          ? CartSummaryModel.fromJson(summaryJson)
          : cart.summary;

      if (!mounted) return;

      setState(() {
        cart = cart.copyWith(coupon: coupon, summary: summary);
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Coupon applied successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> removeCoupon() async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.removeCouponDemo();
      final updatedSummary = service.parseSummary(response);

      if (!mounted) return;

      setState(() {
        cart = cart.copyWith(clearCoupon: true, summary: updatedSummary);
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Coupon removed successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> clearCart() async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final result = await service.clearCartDemo();

      if (!mounted) return;

      setState(() {
        cart = result;
      });

      AppToast.show(
        context,
        message: 'Cart cleared successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  void checkoutDemo() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const CheckoutScreen()),
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

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Cart'),
        actions: [
          if (items.isNotEmpty)
            TextButton(
              onPressed: isActionLoading ? null : clearCart,
              child: const Text('Clear'),
            ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchCart,
              child: items.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.shopping_cart_outlined,
                          size: 90,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Your cart is empty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Add some products to your cart and they will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.lightTextSecondary),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (isActionLoading) const LinearProgressIndicator(),
                        if (isActionLoading) const SizedBox(height: 12),
                        Text(
                          '${cart.summary.totalItems} items in your cart',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 16),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: CartItemCard(
                              item: item,
                              onIncrease: isActionLoading
                                  ? () {}
                                  : () {
                                      updateQuantity(item, item.quantity + 1);
                                    },
                              onDecrease: isActionLoading
                                  ? () {}
                                  : () {
                                      updateQuantity(item, item.quantity - 1);
                                    },
                              onRemove: isActionLoading
                                  ? () {}
                                  : () {
                                      removeItem(item);
                                    },
                            ),
                          );
                        }),
                        const SizedBox(height: 8),
                        ApplyCouponSection(
                          coupon: cart.coupon,
                          isLoading: isActionLoading,
                          onApplyCoupon: applyCoupon,
                          onRemoveCoupon: removeCoupon,
                        ),
                        const SizedBox(height: 18),
                        CartSummarySection(
                          summary: cart.summary,
                          onCheckout: checkoutDemo,
                        ),
                        const SizedBox(height: 40),
                      ],
                    ),
            ),
    );
  }
}
