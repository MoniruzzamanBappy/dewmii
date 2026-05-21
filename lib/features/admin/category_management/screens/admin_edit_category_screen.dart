import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_category_model.dart';
import '../services/admin_category_api_service.dart';
import '../widgets/admin_category_form.dart';

class AdminEditCategoryScreen extends StatefulWidget {
  final AdminCategoryModel category;

  const AdminEditCategoryScreen({super.key, required this.category});

  @override
  State<AdminEditCategoryScreen> createState() =>
      _AdminEditCategoryScreenState();
}

class _AdminEditCategoryScreenState extends State<AdminEditCategoryScreen> {
  final AdminCategoryApiService service = AdminCategoryApiService();

  bool isLoading = false;

  Future<void> updateCategory(Map<String, dynamic> body) async {
    setState(() => isLoading = true);

    try {
      final response = await service.updateCategory(
        categoryId: widget.category.id,
        body: body,
      );

      final category = service.parseCategory(response);

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Category updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(
        context,
        category ??
            widget.category.copyWith(
              name: body['name']?.toString(),
              slug: body['slug']?.toString(),
              description: body['description']?.toString(),
              imageUrl: body['image_url']?.toString(),
              status: body['status']?.toString(),
              sortOrder: body['sort_order'] is int
                  ? body['sort_order'] as int
                  : int.tryParse(body['sort_order']?.toString() ?? ''),
            ),
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = widget.category;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Category')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          _EditHero(category: category),
          const SizedBox(height: 18),
          AdminCategoryForm(
            initialName: category.name,
            initialDescription: category.description,
            initialImageUrl: category.imageUrl,
            initialStatus: category.status,
            initialSortOrder: category.sortOrder,
            isLoading: isLoading,
            submitLabel: 'Update Category',
            onSubmit: updateCategory,
          ),
        ],
      ),
    );
  }
}

class _EditHero extends StatelessWidget {
  final AdminCategoryModel category;

  const _EditHero({required this.category});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 62,
            height: 62,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
            ),
            child: category.imageUrl.isEmpty
                ? const Icon(Icons.category_rounded, color: Colors.white)
                : Image.network(
                    category.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, _, _) =>
                        const Icon(Icons.category_rounded, color: Colors.white),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name.isEmpty ? 'Edit Category' : category.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Update category details, image, status and sort order.',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.86),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
