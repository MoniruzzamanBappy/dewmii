import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/product_review_model.dart';

class ProductReviewCard extends StatelessWidget {
  final ProductReviewModel review;

  const ProductReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final date = review.createdAt == null
        ? 'Recent review'
        : '${review.createdAt!.day}/${review.createdAt!.month}/${review.createdAt!.year}';

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: .96, end: 1),
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
      builder: (context, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        margin: const EdgeInsets.only(bottom: 14),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: scheme.surface,
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: scheme.outlineVariant.withValues(alpha: .55)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? .18 : .05),
              blurRadius: 18,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 23,
                  backgroundColor: AppColors.primary.withValues(alpha: .14),
                  backgroundImage: review.user.avatarUrl != null && review.user.avatarUrl!.isNotEmpty
                      ? NetworkImage(review.user.avatarUrl!)
                      : null,
                  child: review.user.avatarUrl == null || review.user.avatarUrl!.isEmpty
                      ? Text(_initials(review.user.displayName), style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary))
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(review.user.displayName, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                      const SizedBox(height: 2),
                      Text(date, style: theme.textTheme.bodySmall?.copyWith(color: scheme.onSurfaceVariant)),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  decoration: BoxDecoration(
                    color: AppColors.warning.withValues(alpha: .12),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                      const SizedBox(width: 3),
                      Text('${review.rating}', style: const TextStyle(fontWeight: FontWeight.w900)),
                    ],
                  ),
                ),
              ],
            ),
            if (review.comment.isNotEmpty) ...[
              const SizedBox(height: 14),
              Text(review.comment, style: theme.textTheme.bodyMedium?.copyWith(height: 1.45, color: scheme.onSurfaceVariant)),
            ],
            if (review.images.isNotEmpty) ...[
              const SizedBox(height: 14),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: review.images.length,
                  separatorBuilder: (_, _) => const SizedBox(width: 10),
                  itemBuilder: (context, index) => ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      review.images[index],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => Container(
                        width: 80,
                        height: 80,
                        color: scheme.surfaceContainerHighest,
                        child: Icon(Icons.image_not_supported_rounded, color: scheme.onSurfaceVariant),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _initials(String name) {
    final parts = name.trim().split(RegExp(r'\s+')).where((e) => e.isNotEmpty).toList();
    if (parts.isEmpty) return 'U';
    if (parts.length == 1) return parts.first.substring(0, 1).toUpperCase();
    return '${parts.first.substring(0, 1)}${parts.last.substring(0, 1)}'.toUpperCase();
  }
}
