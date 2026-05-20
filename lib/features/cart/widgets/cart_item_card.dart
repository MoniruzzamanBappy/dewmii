import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/cart_item_model.dart';

class CartItemCard extends StatelessWidget {
  final CartItemModel item;
  final VoidCallback onIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onRemove;
  final bool isLoading;

  const CartItemCard({
    super.key,
    required this.item,
    required this.onIncrease,
    required this.onDecrease,
    required this.onRemove,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final surfaceVariant = isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurfaceVariant;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textPrimary = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final textSecondary = isDark
        ? AppColors.darkTextSecondary
        : AppColors.lightTextSecondary;
    final variantText = [
      if (item.size != null) 'Size: ${item.size}',
      if (item.color != null) 'Color: ${item.color}',
      if (item.variantName != null) item.variantName,
    ].join(' • ');

    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.045),
            blurRadius: 24,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Hero(
            tag: 'cart-item-${item.id}',
            child: Container(
              width: 98,
              height: 118,
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                color: surfaceVariant,
                borderRadius: BorderRadius.circular(22),
              ),
              child: item.thumbnail.isEmpty
                  ? const Icon(
                      Icons.image_rounded,
                      color: AppColors.primary,
                      size: 34,
                    )
                  : Image.network(
                      item.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return const Icon(
                          Icons.broken_image_outlined,
                          color: AppColors.primary,
                          size: 34,
                        );
                      },
                    ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w900,
                          fontSize: 15.5,
                          height: 1.22,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    _IconBubbleButton(
                      icon: Icons.delete_outline_rounded,
                      iconColor: AppColors.error,
                      backgroundColor: AppColors.error.withValues(alpha: 0.10),
                      onTap: isLoading ? null : onRemove,
                    ),
                  ],
                ),
                if (variantText.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    variantText,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
                const SizedBox(height: 10),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    Text(
                      '৳${_money(item.price)}',
                      style: const TextStyle(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w900,
                        fontSize: 17,
                      ),
                    ),
                    if (item.hasDiscount)
                      Text(
                        '৳${_money(item.regularPrice)}',
                        style: TextStyle(
                          color: textSecondary,
                          decoration: TextDecoration.lineThrough,
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    if (item.isOutOfStock)
                      _StatusPill(label: 'Out of stock', color: AppColors.error)
                    else if (item.availableStock <= 5)
                      _StatusPill(
                        label: 'Only ${item.availableStock} left',
                        color: AppColors.warning,
                      ),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    _QuantityStepper(
                      quantity: item.quantity,
                      canDecrease: !isLoading && item.quantity > 1,
                      canIncrease:
                          !isLoading &&
                          !item.isOutOfStock &&
                          item.quantity < item.availableStock,
                      onDecrease: onDecrease,
                      onIncrease: onIncrease,
                    ),
                    const Spacer(),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Subtotal',
                          style: TextStyle(
                            color: textSecondary,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '৳${_money(item.effectiveSubtotal)}',
                          style: TextStyle(
                            color: textPrimary,
                            fontSize: 15,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
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

  String _money(num value) {
    if (value % 1 == 0) return value.toInt().toString();
    return value.toStringAsFixed(2);
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final bool canDecrease;
  final bool canIncrease;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;

  const _QuantityStepper({
    required this.quantity,
    required this.canDecrease,
    required this.canIncrease,
    required this.onDecrease,
    required this.onIncrease,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.darkSurfaceVariant
            : AppColors.lightSurfaceVariant,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _IconBubbleButton(
            icon: Icons.remove_rounded,
            onTap: canDecrease ? onDecrease : null,
            size: 32,
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
            ),
          ),
          _IconBubbleButton(
            icon: Icons.add_rounded,
            onTap: canIncrease ? onIncrease : null,
            size: 32,
          ),
        ],
      ),
    );
  }
}

class _IconBubbleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color? iconColor;
  final Color? backgroundColor;

  const _IconBubbleButton({
    required this.icon,
    required this.onTap,
    this.size = 36,
    this.iconColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          backgroundColor ??
          AppColors.primary.withValues(alpha: onTap == null ? 0.06 : 0.12),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(
            icon,
            size: 18,
            color: onTap == null
                ? Theme.of(context).disabledColor
                : iconColor ?? AppColors.primary,
          ),
        ),
      ),
    );
  }
}

class _StatusPill extends StatelessWidget {
  final String label;
  final Color color;

  const _StatusPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}
