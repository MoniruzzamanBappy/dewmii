import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/product_review_model.dart';

class ProductReviewCard extends StatelessWidget {
  final ProductReviewModel review;

  const ProductReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundImage: review.user.avatarUrl != null
                    ? NetworkImage(review.user.avatarUrl!)
                    : null,
                child: review.user.avatarUrl == null
                    ? const Icon(Icons.person_rounded)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  review.user.displayName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 15,
                  ),
                ),
              ),
              Row(
                children: [
                  const Icon(
                    Icons.star_rounded,
                    color: AppColors.warning,
                    size: 18,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '${review.rating}',
                    style: const TextStyle(fontWeight: FontWeight.w800),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review.comment,
            style: const TextStyle(
              height: 1.45,
              color: AppColors.lightTextSecondary,
            ),
          ),
          if (review.images.isNotEmpty) ...[
            const SizedBox(height: 12),
            SizedBox(
              height: 76,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: review.images.length,
                itemBuilder: (context, index) {
                  return Container(
                    width: 76,
                    height: 76,
                    margin: const EdgeInsets.only(right: 10),
                    clipBehavior: Clip.antiAlias,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Image.network(
                      review.images[index],
                      fit: BoxFit.cover,
                    ),
                  );
                },
              ),
            ),
          ],
        ],
      ),
    );
  }
}
