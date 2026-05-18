import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/order_list_item_model.dart';

class OrderCard extends StatelessWidget {
  final OrderListItemModel order;
  final VoidCallback onTap;
  final VoidCallback onTrack;
  final VoidCallback onCancel;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    required this.onTrack,
    required this.onCancel,
  });

  Color get statusColor {
    switch (order.status) {
      case 'delivered':
        return AppColors.success;
      case 'cancelled':
        return AppColors.error;
      case 'processing':
      case 'pending':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final canCancel = order.status == 'pending' || order.status == 'confirmed';

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    order.orderNumber,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    order.status.toUpperCase(),
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${order.itemsCount} items • ${order.paymentMethod.toUpperCase()} • ${order.paymentStatus}',
              style: const TextStyle(
                color: AppColors.lightTextSecondary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '৳${order.total}',
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: onTrack,
                    icon: const Icon(Icons.local_shipping_rounded),
                    label: const Text('Track'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: canCancel ? onCancel : null,
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
