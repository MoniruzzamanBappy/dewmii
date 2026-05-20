import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/cart_summary_model.dart';

class CartSummarySection extends StatelessWidget {
  final CartSummaryModel summary;
  final VoidCallback onCheckout;
  final bool isLoading;

  const CartSummarySection({
    super.key,
    required this.summary,
    required this.onCheckout,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.045),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.receipt_long_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Cart Summary',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SummaryRow(
            label: 'Subtotal',
            value: '৳${_money(summary.subtotal)}',
            textColor: textPrimary,
            mutedColor: textSecondary,
          ),
          _SummaryRow(
            label: 'Discount',
            value: summary.discount > 0
                ? '-৳${_money(summary.discount)}'
                : '৳0',
            valueColor: summary.discount > 0 ? AppColors.success : textPrimary,
            textColor: textPrimary,
            mutedColor: textSecondary,
          ),
          _SummaryRow(
            label: 'Delivery',
            value: '৳${_money(summary.shippingCharge)}',
            textColor: textPrimary,
            mutedColor: textSecondary,
          ),
          _SummaryRow(
            label: 'Tax',
            value: '৳${_money(summary.tax)}',
            textColor: textPrimary,
            mutedColor: textSecondary,
          ),
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            height: 1,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.transparent, border, Colors.transparent],
              ),
            ),
          ),
          _SummaryRow(
            label: 'Total',
            value: '৳${_money(summary.total)}',
            isTotal: true,
            textColor: textPrimary,
            mutedColor: textSecondary,
          ),
          const SizedBox(height: 18),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: summary.totalItems == 0 || isLoading
                  ? null
                  : onCheckout,
              icon: isLoading
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2.2),
                    )
                  : const Icon(Icons.lock_outline_rounded),
              label: Text('Checkout (${summary.totalItems} items)'),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.verified_user_outlined,
                size: 16,
                color: textSecondary,
              ),
              const SizedBox(width: 6),
              Text(
                'Secure checkout',
                style: TextStyle(
                  color: textSecondary,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
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

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  final bool isTotal;
  final Color textColor;
  final Color mutedColor;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.isTotal = false,
    required this.textColor,
    required this.mutedColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal ? textColor : mutedColor,
              fontSize: isTotal ? 18 : 14,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w700,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: valueColor ?? textColor,
              fontSize: isTotal ? 21 : 14,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
