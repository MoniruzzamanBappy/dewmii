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
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? const Color(0xFF151B2D) : Colors.white;
    final border = isDark
        ? Colors.white.withValues(alpha: 0.08)
        : Colors.black.withValues(alpha: 0.06);
    final mutedText = isDark
        ? Colors.white.withValues(alpha: 0.64)
        : AppColors.lightTextSecondary;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: surface,
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: border),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
                  blurRadius: 24,
                  offset: const Offset(0, 14),
                ),
              ],
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _ProductImage(item: item),
                const SizedBox(width: 14),
                Expanded(
                  child: _ProductInfo(
                    item: item,
                    mutedText: mutedText,
                    onRemove: onRemove,
                    onMoveToCart: onMoveToCart,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProductImage extends StatelessWidget {
  final WishlistItemModel item;

  const _ProductImage({required this.item});

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'wishlist-product-${item.productId}',
      child: Container(
        width: 104,
        height: 126,
        clipBehavior: Clip.antiAlias,
        decoration: BoxDecoration(
          color: AppColors.softMuted,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            if (item.thumbnail.isNotEmpty)
              Image.network(
                item.thumbnail,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const _ImageFallback(),
              )
            else
              const _ImageFallback(),
            Positioned(
              top: 8,
              right: 8,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.92),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.10),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.favorite_rounded,
                  color: AppColors.danger,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.softMuted,
      child: const Icon(
        Icons.image_rounded,
        color: AppColors.primary,
        size: 34,
      ),
    );
  }
}

class _ProductInfo extends StatelessWidget {
  final WishlistItemModel item;
  final Color mutedText;
  final VoidCallback onRemove;
  final VoidCallback onMoveToCart;

  const _ProductInfo({
    required this.item,
    required this.mutedText,
    required this.onRemove,
    required this.onMoveToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final price = item.hasDiscount ? item.discountPrice : item.price;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          item.name.isEmpty ? 'Wishlist product' : item.name,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w900,
            height: 1.18,
          ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            _RatingPill(item: item),
            _StockPill(item: item),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Flexible(
              child: Text(
                '৳$price',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ),
            const SizedBox(width: 8),
            if (item.hasDiscount)
              Flexible(
                child: Text(
                  '৳${item.price}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: mutedText,
                    decoration: TextDecoration.lineThrough,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _CircleActionButton(
              tooltip: 'Remove',
              icon: Icons.delete_outline_rounded,
              onTap: onRemove,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: SizedBox(
                height: 44,
                child: ElevatedButton.icon(
                  onPressed: item.isInStock ? onMoveToCart : null,
                  icon: const Icon(Icons.shopping_bag_rounded, size: 18),
                  label: const Text('Move to Cart'),
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _RatingPill extends StatelessWidget {
  final WishlistItemModel item;

  const _RatingPill({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
          const SizedBox(width: 3),
          Text(
            '${item.rating}',
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w900,
            ),
          ),
          if (item.totalReviews > 0) ...[
            const SizedBox(width: 3),
            Text(
              '(${item.totalReviews})',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Theme.of(context).textTheme.bodySmall?.color,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _StockPill extends StatelessWidget {
  final WishlistItemModel item;

  const _StockPill({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isInStock ? AppColors.success : AppColors.warning;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        item.stockLabel,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _CircleActionButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final VoidCallback onTap;

  const _CircleActionButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : AppColors.softMuted,
        shape: const CircleBorder(),
        child: InkWell(
          onTap: onTap,
          customBorder: const CircleBorder(),
          child: SizedBox(
            height: 44,
            width: 44,
            child: Icon(icon, color: AppColors.danger, size: 21),
          ),
        ),
      ),
    );
  }
}
