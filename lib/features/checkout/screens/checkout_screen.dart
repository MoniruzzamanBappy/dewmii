import 'package:dewmii/features/checkout/screens/delivery_method_screen.dart';
import 'package:dewmii/features/checkout/screens/order_review_screen.dart';
import 'package:dewmii/features/checkout/screens/payment_method_screen.dart';
import 'package:dewmii/features/checkout/screens/shipping_address_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/address_model.dart';
import '../models/checkout_model.dart';
import '../models/payment_method_model.dart';
import '../models/shipping_method_model.dart';
import '../services/checkout_api_service.dart';
import '../widgets/checkout_step_card.dart';
import '../widgets/order_summary_card.dart';

class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final CheckoutApiService service = CheckoutApiService();

  bool isLoading = true;
  bool isValidating = false;

  CheckoutModel? checkout;
  AddressModel? selectedAddress;
  ShippingMethodModel? selectedShippingMethod;
  PaymentMethodModel? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    fetchCheckout();
  }

  Future<void> fetchCheckout() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getCheckoutData();
      if (!mounted) return;

      setState(() {
        checkout = result;
        selectedAddress = result?.defaultAddress ?? (result?.addresses.isNotEmpty == true ? result!.addresses.first : null);
        selectedShippingMethod = result?.shippingMethods.isNotEmpty == true ? result!.shippingMethods.first : null;
        selectedPaymentMethod = result?.paymentMethods.isNotEmpty == true ? result!.paymentMethods.first : null;
      });
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: _cleanError(error), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> validateAndContinue() async {
    if (selectedAddress == null || selectedShippingMethod == null || selectedPaymentMethod == null) {
      AppToast.show(
        context,
        message: 'Please select address, delivery and payment method',
        type: ToastType.warning,
      );
      return;
    }

    setState(() => isValidating = true);

    try {
      final response = await service.validateCheckoutDemo(
        addressId: selectedAddress!.id,
        shippingMethodId: selectedShippingMethod!.id,
        paymentMethodId: selectedPaymentMethod!.id,
      );

      if (!mounted) return;

      if (!service.isCheckoutValid(response)) {
        AppToast.show(context, message: 'Checkout validation failed', type: ToastType.error);
        return;
      }

      Navigator.push(
        context,
        PageRouteBuilder(
          pageBuilder: (_, animation, __) => OrderReviewScreen(
            address: selectedAddress!,
            shippingMethod: selectedShippingMethod!,
            paymentMethod: selectedPaymentMethod!,
          ),
          transitionsBuilder: (_, animation, __, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(begin: const Offset(0.05, 0), end: Offset.zero).animate(animation),
                child: child,
              ),
            );
          },
        ),
      );
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: _cleanError(error), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isValidating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = checkout;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bottomColor = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final total = data == null
        ? 0
        : data.summary.subtotal -
            data.summary.discount +
            (selectedShippingMethod?.charge ?? data.summary.shippingCharge) +
            data.summary.tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      bottomNavigationBar: data == null
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                decoration: BoxDecoration(
                  color: bottomColor,
                  border: Border(top: BorderSide(color: border)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: dark ? 0.30 : 0.08),
                      blurRadius: 24,
                      offset: const Offset(0, -10),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Payable', style: TextStyle(fontWeight: FontWeight.w700)),
                          Text(
                            '৳${total.toStringAsFixed(total % 1 == 0 ? 0 : 2)}',
                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
                          ),
                        ],
                      ),
                    ),
                    FilledButton.icon(
                      onPressed: isValidating ? null : validateAndContinue,
                      icon: isValidating
                          ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                          : const Icon(Icons.arrow_forward_rounded),
                      label: const Text('Review'),
                    ),
                  ],
                ),
              ),
            ),
      body: isLoading
          ? const _CheckoutSkeleton()
          : data == null
              ? _EmptyState(onRetry: fetchCheckout)
              : RefreshIndicator(
                  onRefresh: fetchCheckout,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    children: [
                      _HeroCard(items: data.cartItems.length),
                      const SizedBox(height: 18),
                      CheckoutStepCard(
                        title: 'Shipping Address',
                        subtitle: selectedAddress?.fullAddress ?? 'Select delivery address',
                        icon: Icons.location_on_rounded,
                        isComplete: selectedAddress != null,
                        onTap: () async {
                          final address = await Navigator.push<AddressModel>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => ShippingAddressScreen(
                                addresses: data.addresses,
                                selectedAddress: selectedAddress,
                              ),
                            ),
                          );

                          if (address != null) setState(() => selectedAddress = address);
                        },
                      ),
                      CheckoutStepCard(
                        title: 'Delivery Method',
                        subtitle: selectedShippingMethod == null
                            ? 'Select delivery option'
                            : '${selectedShippingMethod!.name} • ${selectedShippingMethod!.formattedCharge}',
                        icon: Icons.local_shipping_rounded,
                        isComplete: selectedShippingMethod != null,
                        onTap: () async {
                          final method = await Navigator.push<ShippingMethodModel>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => DeliveryMethodScreen(selectedMethod: selectedShippingMethod),
                            ),
                          );

                          if (method != null) setState(() => selectedShippingMethod = method);
                        },
                      ),
                      CheckoutStepCard(
                        title: 'Payment Method',
                        subtitle: selectedPaymentMethod?.name ?? 'Select payment',
                        icon: Icons.payment_rounded,
                        isComplete: selectedPaymentMethod != null,
                        onTap: () async {
                          final method = await Navigator.push<PaymentMethodModel>(
                            context,
                            MaterialPageRoute(
                              builder: (_) => PaymentMethodScreen(selectedMethod: selectedPaymentMethod),
                            ),
                          );

                          if (method != null) setState(() => selectedPaymentMethod = method);
                        },
                      ),
                      const SizedBox(height: 12),
                      const Text('Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      ...data.cartItems.map((item) => _CheckoutItemTile(
                            imageUrl: item.thumbnail,
                            name: item.name,
                            quantity: item.quantity,
                            subtotal: item.subtotal,
                          )),
                      const SizedBox(height: 12),
                      OrderSummaryCard(
                        summary: data.summary,
                        shippingOverride: selectedShippingMethod?.charge,
                      ),
                    ],
                  ),
                ),
    );
  }

  String _cleanError(Object error) => error.toString().replaceAll('Exception: ', '').replaceAll('ApiException', '');
}

class _HeroCard extends StatelessWidget {
  final int items;

  const _HeroCard({required this.items});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: dark ? AppColors.darkHeroGradient : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Secure checkout\nfor $items ${items == 1 ? 'item' : 'items'}',
              style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.15),
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.lock_rounded, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

class _CheckoutItemTile extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int quantity;
  final num subtotal;

  const _CheckoutItemTile({
    required this.imageUrl,
    required this.name,
    required this.quantity,
    required this.subtotal,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              width: 58,
              height: 58,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 58,
                height: 58,
                color: AppColors.primary.withValues(alpha: 0.10),
                child: const Icon(Icons.image_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 4),
                Text('Qty: $quantity', style: TextStyle(color: secondary, fontWeight: FontWeight.w700)),
              ],
            ),
          ),
          Text('৳$subtotal', style: const TextStyle(fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}

class _CheckoutSkeleton extends StatelessWidget {
  const _CheckoutSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        6,
        (index) => Container(
          height: index == 0 ? 120 : 82,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(26),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.shopping_bag_outlined, size: 72, color: AppColors.primary),
            const SizedBox(height: 18),
            const Text('No checkout data found', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('Refresh the page or add products to your cart first.', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
