import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../models/admin_user_model.dart';

class AdminRecentOrderTile extends StatelessWidget {
  final AdminUserRecentOrderModel order;

  const AdminRecentOrderTile({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: AppColors.primary.withValues(alpha: 0.12),
            child: const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.orderNumber, style: const TextStyle(fontWeight: FontWeight.w900)),
                const SizedBox(height: 3),
                Text('${order.status} • ${order.paymentStatus}', maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Text('৳${order.total}', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }
}
