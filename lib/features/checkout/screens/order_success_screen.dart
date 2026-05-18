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

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 70),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 72,
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
              style: const TextStyle(
                color: AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    _Row(label: 'Order Number', value: order.orderNumber),
                    _Row(label: 'Status', value: order.status),
                    _Row(label: 'Payment', value: paymentText),
                    _Row(label: 'Total', value: '৳${order.total}'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Continue Shopping'),
            ),
          ],
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;

  const _Row({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: const TextStyle(color: AppColors.lightTextSecondary),
          ),
          const Spacer(),
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
