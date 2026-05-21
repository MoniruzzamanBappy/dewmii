import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/address_model.dart';
import '../models/order_preview_model.dart';
import '../models/order_result_model.dart';
import '../models/payment_method_model.dart';
import '../models/payment_result_model.dart';
import '../models/shipping_method_model.dart';
import '../services/checkout_api_service.dart';
import '../widgets/order_summary_card.dart';
import 'order_failed_screen.dart';
import 'order_success_screen.dart';

class OrderReviewScreen extends StatefulWidget {
  final AddressModel address;
  final ShippingMethodModel shippingMethod;
  final PaymentMethodModel paymentMethod;

  const OrderReviewScreen({
    super.key,
    required this.address,
    required this.shippingMethod,
    required this.paymentMethod,
  });

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  final CheckoutApiService service = CheckoutApiService();

  bool isLoading = true;
  bool isPlacingOrder = false;
  OrderPreviewModel? preview;

  @override
  void initState() {
    super.initState();
    fetchPreview();
  }

  Future<void> fetchPreview() async {
    try {
      final result = await service.previewOrderDemo();
      if (!mounted) return;
      setState(() => preview = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: _cleanError(error), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> placeOrder() async {
    setState(() => isPlacingOrder = true);

    try {
      final OrderResultModel? order = await service.placeOrderDemo(
        addressId: widget.address.id,
        shippingMethodId: widget.shippingMethod.id,
        paymentMethodId: widget.paymentMethod.id,
      );

      if (!mounted) return;

      if (order == null) {
        _openFailed('Could not place your order. Please try again.');
        return;
      }

      PaymentResultModel? payment;
      if (widget.paymentMethod.isOnline) {
        payment = await service.initiatePaymentDemo(orderId: order.id);
      }

      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: order, payment: payment),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      _openFailed(_cleanError(error));
    } finally {
      if (mounted) setState(() => isPlacingOrder = false);
    }
  }

  void _openFailed(String message) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => OrderFailedScreen(message: message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = preview;
    final dark = Theme.of(context).brightness == Brightness.dark;
    final bottomColor = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final payable = data == null
        ? 0
        : data.summary.subtotal - data.summary.discount + widget.shippingMethod.charge + data.summary.tax;

    return Scaffold(
      appBar: AppBar(title: const Text('Review Order')),
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
                child: FilledButton.icon(
                  onPressed: isPlacingOrder ? null : placeOrder,
                  icon: isPlacingOrder
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.verified_rounded),
                  label: Text(isPlacingOrder ? 'Placing Order...' : 'Place Order • ৳${payable.toStringAsFixed(payable % 1 == 0 ? 0 : 2)}'),
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
              ? _PreviewEmptyState(onRetry: fetchPreview)
              : RefreshIndicator(
                  onRefresh: fetchPreview,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
                    children: [
                      _ReviewHero(paymentMethod: widget.paymentMethod.name),
                      const SizedBox(height: 18),
                      _InfoCard(
                        icon: Icons.location_on_rounded,
                        title: 'Deliver to',
                        subtitle: '${widget.address.name}\n${widget.address.phone}\n${widget.address.fullAddress}',
                      ),
                      _InfoCard(
                        icon: Icons.local_shipping_rounded,
                        title: 'Delivery',
                        subtitle: '${widget.shippingMethod.name} • ${widget.shippingMethod.formattedCharge}\n${widget.shippingMethod.estimatedDays}',
                      ),
                      _InfoCard(
                        icon: Icons.payment_rounded,
                        title: 'Payment',
                        subtitle: '${widget.paymentMethod.name}\n${widget.paymentMethod.description.isEmpty ? (widget.paymentMethod.isOnline ? 'Online payment' : 'Cash on delivery') : widget.paymentMethod.description}',
                      ),
                      const SizedBox(height: 8),
                      const Text('Order Items', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 12),
                      ...data.items.map((item) => _ReviewItem(
                            imageUrl: item.thumbnail,
                            name: item.name,
                            quantity: item.quantity,
                            subtotal: item.subtotal,
                          )),
                      const SizedBox(height: 12),
                      OrderSummaryCard(
                        summary: data.summary,
                        shippingOverride: widget.shippingMethod.charge,
                      ),
                    ],
                  ),
                ),
    );
  }

  String _cleanError(Object error) => error.toString().replaceAll('Exception: ', '').replaceAll('ApiException', '');
}

class _ReviewHero extends StatelessWidget {
  final String paymentMethod;

  const _ReviewHero({required this.paymentMethod});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: dark ? AppColors.darkHeroGradient : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Row(
        children: [
          const Expanded(
            child: Text(
              'Review everything\nbefore placing order',
              style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900, height: 1.15),
            ),
          ),
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.22),
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Icon(Icons.fact_check_rounded, color: Colors.white, size: 30),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(17),
            ),
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 5),
                Text(subtitle, style: TextStyle(color: secondary, height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ReviewItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final int quantity;
  final num subtotal;

  const _ReviewItem({
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
              errorBuilder: (_, _, _) => Container(
                width: 58,
                height: 58,
                color: AppColors.primary.withValues(alpha: 0.10),
                child: const Icon(Icons.image_rounded, color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('৳$subtotal', style: const TextStyle(fontWeight: FontWeight.w900)),
              Text('Qty $quantity', style: TextStyle(color: secondary, fontWeight: FontWeight.w700)),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewEmptyState extends StatelessWidget {
  final VoidCallback onRetry;

  const _PreviewEmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 72, color: AppColors.primary),
            const SizedBox(height: 18),
            const Text('Preview unavailable', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('We could not load the order preview.', textAlign: TextAlign.center),
            const SizedBox(height: 20),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
