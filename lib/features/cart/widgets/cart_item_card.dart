import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final variantText = [
      if (item.size != null) 'Size: ${item.size}',
      if (item.color != null) 'Color: ${item.color}',
      if (item.variantName != null) 'Variant: ${item.variantName}',
    ].join(' • ');

    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 92,
            height: 104,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.softMuted,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Image.network(
              item.thumbnail,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) {
                return const Icon(
                  Icons.image_rounded,
                  color: AppColors.primary,
                );
              },
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
                if (variantText.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    variantText,
                    style: const TextStyle(
                      color: AppColors.lightTextSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
                const SizedBox(height: 8),
                Row(
                  children: [
                    Text(
                      '৳${item.price}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    if (item.regularPrice > item.price)
                      Text(
                        '৳${item.regularPrice}',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    IconButton.filledTonal(
                      onPressed: item.quantity > 1 ? onDecrease : null,
                      icon: const Icon(Icons.remove_rounded),
                      iconSize: 18,
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '${item.quantity}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    IconButton.filledTonal(
                      onPressed: item.quantity < item.availableStock
                          ? onIncrease
                          : null,
                      icon: const Icon(Icons.add_rounded),
                      iconSize: 18,
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: onRemove,
                      icon: const Icon(
                        Icons.delete_outline_rounded,
                        color: AppColors.error,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
