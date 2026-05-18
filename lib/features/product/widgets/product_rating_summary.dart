import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/product_review_model.dart';

class ProductRatingSummary extends StatelessWidget {
  final ProductReviewSummaryModel summary;

  const ProductRatingSummary({super.key, required this.summary});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Row(
        children: [
          Column(
            children: [
              Text(
                '${summary.averageRating}',
                style: const TextStyle(
                  fontSize: 34,
                  fontWeight: FontWeight.w900,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 4),
              const Row(
                children: [
                  Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                  Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                  Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                  Icon(Icons.star_rounded, color: AppColors.warning, size: 18),
                  Icon(
                    Icons.star_half_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${summary.totalReviews} reviews',
                style: const TextStyle(color: AppColors.lightTextSecondary),
              ),
            ],
          ),
          const SizedBox(width: 22),
          Expanded(
            child: Column(
              children: [5, 4, 3, 2, 1].map((star) {
                final count = summary.ratingCount['$star'] ?? 0;
                final progress = summary.totalReviews == 0
                    ? 0.0
                    : (count as num).toDouble() / summary.totalReviews;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    children: [
                      Text('$star'),
                      const SizedBox(width: 4),
                      const Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: LinearProgressIndicator(
                          value: progress,
                          minHeight: 7,
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text('$count', style: const TextStyle(fontSize: 12)),
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
