import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../models/admin_product_model.dart';

class AdminProductCard extends StatelessWidget {
  final AdminProductModel product;
  final VoidCallback onEdit;
  final VoidCallback onStock;
  final VoidCallback onDelete;

  const AdminProductCard({
    super.key,
    required this.product,
    required this.onEdit,
    required this.onStock,
    required this.onDelete,
  });

  Color get stockColor {
    switch (product.stockStatus) {
      case 'in_stock':
        return AppColors.success;
      case 'low_stock':
        return AppColors.warning;
      case 'out_of_stock':
        return AppColors.error;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.16 : 0.045),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'admin-product-${product.id}',
            child: Container(
              width: 86,
              height: 104,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: AppColors.softMuted,
                borderRadius: BorderRadius.circular(18),
              ),
              child: product.thumbnail.isEmpty
                  ? const Icon(Icons.image_rounded, color: AppColors.primary)
                  : Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => const Icon(
                        Icons.image_rounded,
                        color: AppColors.primary,
                      ),
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name.isEmpty ? 'Untitled product' : product.name,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                ),
                const SizedBox(height: 5),
                Text(
                  [
                    if (product.sku.isNotEmpty) product.sku,
                    if (product.categoryName.isNotEmpty) product.categoryName,
                    if (product.brandName.isNotEmpty) product.brandName,
                  ].join(' • '),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 9),
                Row(
                  children: [
                    Text(
                      '৳${product.sellingPrice}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    if (product.discountPrice > 0 && product.discountPrice < product.price) ...[
                      const SizedBox(width: 8),
                      Text(
                        '৳${product.price}',
                        style: TextStyle(
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.lightTextSecondary,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 9),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(
                      label: product.status.isEmpty ? 'draft' : product.status,
                      color: product.isActive ? AppColors.success : AppColors.muted,
                    ),
                    _Badge(
                      label: '${product.stockStatus.isEmpty ? 'stock' : product.stockStatus} • ${product.stock}',
                      color: stockColor,
                    ),
                    if (product.isFeatured)
                      const _Badge(label: 'featured', color: AppColors.primary),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onEdit,
                        icon: const Icon(Icons.edit_rounded, size: 18),
                        label: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onStock,
                        icon: const Icon(Icons.inventory_rounded, size: 18),
                        label: const Text('Stock'),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Delete product',
                      onPressed: onDelete,
                      icon: const Icon(Icons.delete_outline_rounded),
                      color: AppColors.error,
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

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.replaceAll('_', ' '),
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}
