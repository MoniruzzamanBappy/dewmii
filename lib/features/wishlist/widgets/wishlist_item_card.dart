import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/wishlist_item_model.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItemModel item;
  final VoidCallback onTap;
  final VoidCallback onRemove;
  final VoidCallback onMoveToCart;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onTap,
    required this.onRemove,
    required this.onMoveToCart,
  });

  @override
  Widget build(BuildContext context) {
    final hasDiscount = item.discountPrice < item.price;

    return GestureDetector(
      onTap: onTap,
      child: Container(
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
              width: 96,
              height: 112,
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
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 17,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${item.totalReviews})',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '৳${item.discountPrice}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (hasDiscount)
                        Text(
                          '৳${item.price}',
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                            decoration: TextDecoration.lineThrough,
                            fontSize: 12,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: item.stockStatus == 'in_stock'
                          ? AppColors.success.withValues(alpha: 0.10)
                          : AppColors.warning.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      item.stockStatus.replaceAll('_', ' '),
                      style: TextStyle(
                        color: item.stockStatus == 'in_stock'
                            ? AppColors.success
                            : AppColors.warning,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: onRemove,
                          icon: const Icon(Icons.delete_outline_rounded),
                          label: const Text('Remove'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: onMoveToCart,
                          icon: const Icon(Icons.shopping_cart_rounded),
                          label: const Text('Move'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
