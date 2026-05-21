import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/product_review_model.dart';

class ProductRatingSummary extends StatelessWidget {
  final ProductReviewSummaryModel summary;

  const ProductRatingSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final average = summary.averageRating.toDouble();

    return AnimatedContainer(
      duration: const Duration(milliseconds: 250),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: colorScheme.outlineVariant.withValues(alpha: .55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: theme.brightness == Brightness.dark ? .22 : .06),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 104,
            padding: const EdgeInsets.symmetric(vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Column(
              children: [
                Text(
                  average.toStringAsFixed(average.truncateToDouble() == average ? 0 : 1),
                  style: const TextStyle(fontSize: 34, fontWeight: FontWeight.w900, color: Colors.white),
                ),
                const SizedBox(height: 6),
                _Stars(value: average, color: Colors.white),
                const SizedBox(height: 6),
                Text('${summary.totalReviews} reviews', style: const TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final countValue = summary.ratingCount['$star'] ?? summary.ratingCount[star] ?? 0;
                final count = countValue is num ? countValue.toInt() : int.tryParse(countValue.toString()) ?? 0;
                final progress = summary.totalReviews == 0 ? 0.0 : count / summary.totalReviews;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Row(
                    children: [
                      SizedBox(width: 18, child: Text('$star', style: theme.textTheme.labelMedium)),
                      const Icon(Icons.star_rounded, size: 15, color: AppColors.warning),
                      const SizedBox(width: 8),
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(999),
                          child: LinearProgressIndicator(
                            value: progress.clamp(0, 1),
                            minHeight: 8,
                            backgroundColor: colorScheme.surfaceContainerHighest,
                            color: AppColors.warning,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      SizedBox(width: 28, child: Text('$count', textAlign: TextAlign.end, style: theme.textTheme.labelSmall)),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _Stars extends StatelessWidget {
  final double value;
  final Color color;

  const _Stars({required this.value, required this.color});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final icon = value >= index + 1
            ? Icons.star_rounded
            : value > index
                ? Icons.star_half_rounded
                : Icons.star_border_rounded;
        return Icon(icon, size: 16, color: color);
      }),
    );
  }
}
