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

  Future<void> fetchPreview() async {
    try {
      final result = await service.previewOrderDemo();

      if (!mounted) return;

      setState(() {
        preview = result;
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

  Future<void> placeOrder() async {
    setState(() {
      isPlacingOrder = true;
    });

    try {
      final OrderResultModel? order = await service.placeOrderDemo();

      if (!mounted) return;

      if (order == null) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const OrderFailedScreen(message: 'Order could not be placed'),
          ),
        );
        return;
      }

      PaymentResultModel? payment;

      if (widget.paymentMethod.isOnline) {
        payment = await service.initiatePaymentDemo();
        payment = await service.verifyPaymentDemo();
      }

      if (!mounted) return;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
          builder: (_) => OrderSuccessScreen(order: order, payment: payment),
        ),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrderFailedScreen(
            message: error.toString().replaceAll('Exception: ', ''),
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          isPlacingOrder = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchPreview();
  }

  @override
  Widget build(BuildContext context) {
    final data = preview;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Review')),
      bottomNavigationBar: data == null
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.lightSurface,
                  border: Border(top: BorderSide(color: AppColors.lightBorder)),
                ),
                child: ElevatedButton(
                  onPressed: isPlacingOrder ? null : placeOrder,
                  child: isPlacingOrder
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : Text('Place Order • ৳${data.summary.total}'),
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text('No preview found'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                const Text(
                  'Review Your Order',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 18),
                _InfoBox(
                  title: 'Address',
                  value: widget.address.fullAddress,
                  icon: Icons.location_on_rounded,
                ),
                _InfoBox(
                  title: 'Delivery',
                  value:
                      '${widget.shippingMethod.name} • ৳${widget.shippingMethod.charge}',
                  icon: Icons.local_shipping_rounded,
                ),
                _InfoBox(
                  title: 'Payment',
                  value: widget.paymentMethod.name,
                  icon: Icons.payment_rounded,
                ),
                const SizedBox(height: 14),
                const Text(
                  'Items',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 12),
                ...data.items.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      leading: Image.network(
                        item.thumbnail,
                        width: 54,
                        height: 54,
                        fit: BoxFit.cover,
                      ),
                      title: Text(item.name),
                      subtitle: Text('Qty: ${item.quantity}'),
                      trailing: Text(
                        '৳${item.subtotal}',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                OrderSummaryCard(summary: data.summary),
                const SizedBox(height: 90),
              ],
            ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoBox({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.softMuted,
            child: Icon(icon, color: AppColors.primary),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.lightTextSecondary,
                    fontSize: 13,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
