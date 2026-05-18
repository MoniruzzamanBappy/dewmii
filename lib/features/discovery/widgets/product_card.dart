import 'package:dewmii/features/product/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/product_model.dart';

class ProductCard extends StatelessWidget {
  final ProductModel product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    final hasDiscount = product.discountPrice < product.price;

    return GestureDetector(
      onTap:
          onTap ??
          () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => ProductDetailsScreen(productId: product.id),
              ),
            );
          },
      child: Container(
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
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.network(
                      product.thumbnail,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) {
                        return Container(
                          color: AppColors.softMuted,
                          child: const Icon(
                            Icons.image_rounded,
                            color: AppColors.primary,
                          ),
                        );
                      },
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: CircleAvatar(
                      radius: 16,
                      backgroundColor: Colors.white,
                      child: Icon(
                        product.isWishlist
                            ? Icons.favorite_rounded
                            : Icons.favorite_border_rounded,
                        size: 18,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                  if (hasDiscount)
                    Positioned(
                      top: 10,
                      left: 10,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          '-${product.discountPercentage}%',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: AppColors.warning,
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '${product.rating}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.totalReviews})',
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      Text(
                        '৳${product.discountPrice}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(width: 7),
                      if (hasDiscount)
                        Text(
                          '৳${product.price}',
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                            fontSize: 12,
                            decoration: TextDecoration.lineThrough,
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
