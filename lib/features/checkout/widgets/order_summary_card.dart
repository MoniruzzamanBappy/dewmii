import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../cart/models/cart_summary_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final CartSummaryModel summary;

  const OrderSummaryCard({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Order Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          _Row(label: 'Subtotal', value: '৳${summary.subtotal}'),
          _Row(
            label: 'Discount',
            value: '-৳${summary.discount}',
            color: AppColors.success,
          ),
          _Row(label: 'Shipping', value: '৳${summary.shippingCharge}'),
          _Row(label: 'Tax', value: '৳${summary.tax}'),
          const Divider(height: 26),
          _Row(label: 'Total', value: '৳${summary.total}', isTotal: true),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isTotal;

  const _Row({
    required this.label,
    required this.value,
    this.color,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? AppColors.lightTextPrimary
                  : AppColors.lightTextSecondary,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.lightTextPrimary,
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
