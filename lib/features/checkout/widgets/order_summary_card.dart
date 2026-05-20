import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../cart/models/cart_summary_model.dart';

class OrderSummaryCard extends StatelessWidget {
  final CartSummaryModel summary;
  final num? shippingOverride;

  const OrderSummaryCard({super.key, required this.summary, this.shippingOverride});

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final surface = dark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = dark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
    final shipping = shippingOverride ?? summary.shippingCharge;
    final total = shippingOverride == null
        ? summary.total
        : summary.subtotal - summary.discount + shipping + summary.tax;

    return Container(
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(28),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: dark ? 0.20 : 0.06),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Order Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
              ],
            ),
            const SizedBox(height: 18),
            _row('Subtotal', summary.subtotal, secondary),
            _row('Discount', -summary.discount, secondary),
            _row('Shipping', shipping, secondary),
            _row('Tax', summary.tax, secondary),
            if ((summary.couponCode ?? '').isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Chip(
                  label: Text('Coupon: ${summary.couponCode}'),
                  avatar: const Icon(Icons.local_offer_rounded, size: 16),
                ),
              ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Divider(color: border),
            ),
            Row(
              children: [
                const Expanded(
                  child: Text('Total', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
                ),
                Text(
                  _money(total),
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: AppColors.primary),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, num amount, Color color) {
    final isNegative = amount < 0;
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(child: Text(label, style: TextStyle(color: color, fontWeight: FontWeight.w600))),
          Text(
            isNegative ? '-${_money(amount.abs())}' : _money(amount),
            style: TextStyle(
              color: isNegative ? AppColors.success : null,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  String _money(num value) => '৳${value.toStringAsFixed(value % 1 == 0 ? 0 : 2)}';
}
