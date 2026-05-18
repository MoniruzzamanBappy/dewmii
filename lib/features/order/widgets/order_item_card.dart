import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/order_details_model.dart';

class OrderItemCard extends StatelessWidget {
  final OrderDetailsItemModel item;

  const OrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final variantText = [
      if (item.size != null) 'Size: ${item.size}',
      if (item.color != null) 'Color: ${item.color}',
    ].join(' • ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Container(
            width: 70,
            height: 78,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.softMuted,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Image.network(item.thumbnail, fit: BoxFit.cover),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                if (variantText.isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    variantText,
                    style: const TextStyle(color: AppColors.lightTextSecondary),
                  ),
                ],
                const SizedBox(height: 6),
                Text(
                  'Qty: ${item.quantity}',
                  style: const TextStyle(color: AppColors.lightTextSecondary),
                ),
              ],
            ),
          ),
          Text(
            '৳${item.subtotal}',
            style: const TextStyle(
              color: AppColors.primary,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}
