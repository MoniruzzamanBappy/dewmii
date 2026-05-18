import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback? onTap;

  const CategoryCard({super.key, required this.category, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 92,
        child: Column(
          children: [
            Container(
              width: 76,
              height: 76,
              decoration: BoxDecoration(
                color: AppColors.softMuted,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.lightBorder),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.network(
                category.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) {
                  return const Icon(
                    Icons.category_rounded,
                    color: AppColors.primary,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
            Text(
              category.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
          ],
        ),
      ),
    );
  }
}
