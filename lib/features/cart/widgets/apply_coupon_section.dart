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
  final couponController = TextEditingController(text: 'WELCOME10');

  @override
  void dispose() {
    couponController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final coupon = widget.coupon;

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
            'Apply Coupon',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          if (coupon != null)
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.success.withValues(alpha: 0.35),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.local_offer_rounded,
                    color: AppColors.success,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '${coupon.code} applied — ৳${coupon.discountAmount} off',
                      style: const TextStyle(
                        color: AppColors.success,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: widget.isLoading ? null : widget.onRemoveCoupon,
                    child: const Text('Remove'),
                  ),
                ],
              ),
            )
          else
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: couponController,
                    decoration: const InputDecoration(
                      hintText: 'Enter coupon code',
                      prefixIcon: Icon(Icons.local_offer_outlined),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  height: 54,
                  child: ElevatedButton(
                    onPressed: widget.isLoading
                        ? null
                        : () {
                            widget.onApplyCoupon(couponController.text.trim());
                          },
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2.3),
                          )
                        : const Text('Apply'),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
