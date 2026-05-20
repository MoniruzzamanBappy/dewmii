import 'package:dewmii/shared/widgets/navigation/main_navigation_shell.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/order_result_model.dart';
import '../models/payment_result_model.dart';

class OrderSuccessScreen extends StatelessWidget {
  final OrderResultModel order;
  final PaymentResultModel? payment;

  const OrderSuccessScreen({super.key, required this.order, this.payment});

  @override
  Widget build(BuildContext context) {
    final paymentText = payment == null
        ? 'Payment method: ${order.paymentMethod.toUpperCase()}'
        : 'Payment: ${payment!.paymentStatus.toUpperCase()}';
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 42),
            TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.7, end: 1),
              duration: const Duration(milliseconds: 520),
              curve: Curves.elasticOut,
              builder: (context, value, child) => Transform.scale(scale: value, child: child),
              child: Container(
                width: 118,
                height: 118,
                margin: const EdgeInsets.symmetric(horizontal: 100),
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check_circle_rounded, color: AppColors.success, size: 78),
              ),
            ),
            const SizedBox(height: 28),
            const Text(
              'Order Placed Successfully!',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              'Your order ${order.orderNumber} has been placed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: secondary, height: 1.4),
            ),
            const SizedBox(height: 28),
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: surface,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: border),
              ),
              child: Column(
                children: [
                  _row('Order Number', order.orderNumber),
                  _row('Status', order.status.toUpperCase()),
                  _row('Payment', paymentText),
                  _row('Total', '৳${order.total} ${order.currency}'),
                  if ((payment?.transactionId ?? '').isNotEmpty)
                    _row('Transaction ID', payment!.transactionId),
                ],
              ),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to Home'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.shopping_bag_rounded),
              label: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700))),
          const SizedBox(width: 12),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w900),
            ),
          ),
        ],
      ),
    );
  }
}
