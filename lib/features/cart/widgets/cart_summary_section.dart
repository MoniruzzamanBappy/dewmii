import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/cart_summary_model.dart';

class CartSummarySection extends StatelessWidget {
  final CartSummaryModel summary;
  final VoidCallback onCheckout;

  const CartSummarySection({
    super.key,
    required this.summary,
    required this.onCheckout,
  });

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
            'Cart Summary',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 16),
          _SummaryRow(label: 'Subtotal', value: '৳${summary.subtotal}'),
          _SummaryRow(
            label: 'Discount',
            value: '-৳${summary.discount}',
            valueColor: AppColors.success,
          ),
          _SummaryRow(label: 'Delivery', value: '৳${summary.shippingCharge}'),
          _SummaryRow(label: 'Tax', value: '৳${summary.tax}'),
          const Divider(height: 26),
          _SummaryRow(
            label: 'Total',
            value: '৳${summary.total}',
            isTotal: true,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: summary.totalItems == 0 ? null : onCheckout,
              child: Text('Checkout (${summary.totalItems} items)'),
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
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
              color: valueColor ?? AppColors.lightTextPrimary,
              fontSize: isTotal ? 20 : 14,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
