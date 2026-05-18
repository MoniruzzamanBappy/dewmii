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

    return Scaffold(
      appBar: AppBar(title: Text(category.name)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: Image.network(
                    category.imageUrl,
                    width: 82,
                    height: 82,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) {
                      return Container(
                        width: 82,
                        height: 82,
                        color: AppColors.softMuted,
                        child: const Icon(Icons.category_rounded),
                      );
                    },
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                          color: AppColors.lightTextPrimary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        category.description.isEmpty
                            ? 'Explore products in ${category.name}'
                            : category.description,
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
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
          const SizedBox(height: 24),
          Text(
            hasChildren ? 'Subcategories' : 'No subcategories available',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          if (hasChildren)
            ...category.children.map((child) {
              return Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(child.imageUrl),
                  ),
                  title: Text(child.name),
                  subtitle: Text(child.slug),
                  trailing: const Icon(Icons.arrow_forward_ios_rounded),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListingScreen(
                          title: child.name,
                          categoryId: child.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
        ],
      ),
    );
  }
}
