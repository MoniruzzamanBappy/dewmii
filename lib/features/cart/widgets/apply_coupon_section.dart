import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/cart_coupon_model.dart';

class ApplyCouponSection extends StatefulWidget {
  final CartCouponModel? coupon;
  final bool isLoading;
  final ValueChanged<String> onApplyCoupon;
  final VoidCallback onRemoveCoupon;

  const ApplyCouponSection({
    super.key,
    required this.coupon,
    required this.isLoading,
    required this.onApplyCoupon,
    required this.onRemoveCoupon,
  });

  @override
  State<ApplyCouponSection> createState() => _ApplyCouponSectionState();
}

class _ApplyCouponSectionState extends State<ApplyCouponSection> {
  final couponController = TextEditingController();
  final focusNode = FocusNode();

  @override
  void dispose() {
    focusNode.dispose();
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coupon = widget.coupon;
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

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.045),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 260),
        switchInCurve: Curves.easeOutCubic,
        switchOutCurve: Curves.easeInCubic,
        child: coupon != null
            ? _AppliedCouponCard(
                key: ValueKey('coupon-${coupon.code}'),
                coupon: coupon,
                isLoading: widget.isLoading,
                textPrimary: textPrimary,
                textSecondary: textSecondary,
                onRemove: widget.onRemoveCoupon,
              )
            : Column(
                key: const ValueKey('coupon-input'),
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 42,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: const Icon(
                          Icons.local_offer_outlined,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Apply Coupon',
                              style: TextStyle(
                                color: textPrimary,
                                fontSize: 18,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Use promo codes to save more.',
                              style: TextStyle(
                                color: textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: couponController,
                          focusNode: focusNode,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.done,
                          maxLines: 1,
                          onSubmitted: (_) => _apply(),
                          decoration: InputDecoration(
                            hintText: 'Coupon code',
                            prefixIcon: const Icon(
                              Icons.confirmation_number_outlined,
                            ),
                            filled: true,
                            fillColor: isDark
                                ? AppColors.darkSurfaceVariant
                                : AppColors.lightSurfaceVariant,
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        height: 54,
                        child: FilledButton.icon(
                          onPressed: widget.isLoading ? null : _apply,
                          icon: widget.isLoading
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.2,
                                  ),
                                )
                              : const Icon(Icons.arrow_forward_rounded),
                          label: const Text('Apply'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }

  void _apply() {
    final code = couponController.text.trim();
    focusNode.unfocus();
    widget.onApplyCoupon(code);
  }
}

class _AppliedCouponCard extends StatelessWidget {
  final CartCouponModel coupon;
  final bool isLoading;
  final Color textPrimary;
  final Color textSecondary;
  final VoidCallback onRemove;

  const _AppliedCouponCard({
    super.key,
    required this.coupon,
    required this.isLoading,
    required this.textPrimary,
    required this.textSecondary,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.success.withValues(alpha: 0.15),
            AppColors.success.withValues(alpha: 0.06),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.30)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: const BoxDecoration(
              color: AppColors.success,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${coupon.code} applied',
                  style: TextStyle(
                    color: textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'You saved ৳${_money(coupon.discountAmount)}',
                  style: const TextStyle(
                    color: AppColors.success,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (coupon.minimumOrderAmount > 0) ...[
                  const SizedBox(height: 3),
                  Text(
                    'Minimum order ৳${_money(coupon.minimumOrderAmount)}',
                    style: TextStyle(color: textSecondary, fontSize: 12),
                  ),
                ],
              ],
            ),
          ),
          TextButton(
            onPressed: isLoading ? null : onRemove,
            child: const Text('Remove'),
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
