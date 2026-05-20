import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/order_details_model.dart';

class OrderItemCard extends StatelessWidget {
  final OrderDetailsItemModel item;

  const OrderItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final variantText = [
      if ((item.size ?? '').isNotEmpty) 'Size: ${item.size}',
      if ((item.color ?? '').isNotEmpty) 'Color: ${item.color}',
    ].join(' • ');

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'order-item-${item.id}-${item.productId}',
            child: Container(
              width: 74,
              height: 82,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: theme.colorScheme.primary.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(18),
              ),
              child: item.thumbnail.isEmpty
                  ? Icon(Icons.shopping_bag_rounded, color: theme.colorScheme.primary)
                  : Image.network(
                      item.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Icon(Icons.shopping_bag_rounded, color: theme.colorScheme.primary),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.name.isEmpty ? 'Product item' : item.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                if (variantText.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(variantText, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.62))),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    _Chip(text: 'Qty ${item.quantity}'),
                    const SizedBox(width: 8),
                    _Chip(text: _money(item.price)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(_money(item.subtotal), style: theme.textTheme.titleMedium?.copyWith(color: AppColors.primary, fontWeight: FontWeight.w900)),
        ],
      ),
    );
  }

  String _money(num value) => '৳${value % 1 == 0 ? value.toInt() : value.toStringAsFixed(2)}';
}

class _Chip extends StatelessWidget {
  final String text;

  const _Chip({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(text, style: Theme.of(context).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w800)),
    );
  }
}
