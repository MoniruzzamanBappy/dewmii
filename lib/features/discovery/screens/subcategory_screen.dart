import 'package:dewmii/features/discovery/screens/product_listing_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/category_model.dart';

class SubcategoryScreen extends StatelessWidget {
  final CategoryModel category;

  const SubcategoryScreen({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    final hasChildren = category.children.isNotEmpty;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
        children: [
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              gradient: theme.brightness == Brightness.dark
                  ? AppColors.darkHeroGradient
                  : AppColors.heroGradient,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.14),
                  blurRadius: 26,
                  offset: const Offset(0, 16),
                ),
              ],
            ),
            child: Row(
              children: [
                Hero(
                  tag: 'category-${category.id}',
                  child: Container(
                    width: 88,
                    height: 88,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.70),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.35),
                      ),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: category.imageUrl.isEmpty
                        ? const Icon(
                            Icons.category_rounded,
                            color: AppColors.primary,
                            size: 34,
                          )
                        : Image.network(
                            category.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const Icon(
                              Icons.category_rounded,
                              color: AppColors.primary,
                              size: 34,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w900,
                          letterSpacing: -0.6,
                          height: 1.05,
                        ),
                      ),
                      const SizedBox(height: 7),
                      Text(
                        category.description.isEmpty
                            ? 'Explore products in ${category.name}'
                            : category.description,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                          height: 1.35,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 56,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductListingScreen(
                      title: category.name,
                      categoryId: category.id,
                    ),
                  ),
                );
              },
              icon: const Icon(Icons.grid_view_rounded),
              label: Text('View ${category.name} Products'),
            ),
          ),
          const SizedBox(height: 26),
          Row(
            children: [
              Text(
                hasChildren ? 'Subcategories' : 'No subcategories available',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w900,
                ),
              ),
              const Spacer(),
              if (hasChildren)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.10),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    '${category.children.length}',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 14),
          if (hasChildren)
            ...category.children.asMap().entries.map((entry) {
              final index = entry.key;
              final child = entry.value;

              return TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: 1),
                duration: Duration(milliseconds: 320 + index * 45),
                curve: Curves.easeOutCubic,
                builder: (context, value, animatedChild) {
                  return Opacity(
                    opacity: value,
                    child: Transform.translate(
                      offset: Offset(0, 14 * (1 - value)),
                      child: animatedChild,
                    ),
                  );
                },
                child: _SubcategoryTile(child: child),
              );
            }),
        ],
      ),
    );
  }
}

class _SubcategoryTile extends StatelessWidget {
  final CategoryModel child;

  const _SubcategoryTile({required this.child});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: theme.dividerColor.withValues(alpha: 0.55)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.16 : 0.045,
            ),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Container(
            width: 54,
            height: 54,
            color: AppColors.softMuted,
            child: child.imageUrl.isEmpty
                ? const Icon(Icons.category_rounded, color: AppColors.primary)
                : Image.network(
                    child.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.category_rounded,
                      color: AppColors.primary,
                    ),
                  ),
          ),
        ),
        title: Text(
          child.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Text(
          child.description.isEmpty ? child.slug : child.description,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.arrow_forward_rounded,
            color: AppColors.primary,
            size: 18,
          ),
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  ProductListingScreen(title: child.name, categoryId: child.id),
            ),
          );
        },
      ),
    );
  }
}
