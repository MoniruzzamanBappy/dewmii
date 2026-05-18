import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/banner_model.dart';

class BannerCard extends StatelessWidget {
  final BannerModel banner;
  final VoidCallback? onTap;

  const BannerCard({super.key, required this.banner, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24),
          gradient: AppColors.primaryGradient,
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.18),
              blurRadius: 22,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Stack(
          children: [
            Positioned.fill(
              child: Image.network(
                banner.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return const SizedBox();
                },
              ),
            ),
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.28),
                ),
              ),
            ),
            Positioned(
              left: 18,
              right: 18,
              bottom: 18,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    banner.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    banner.subtitle,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      height: 1.3,
                    ),
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
