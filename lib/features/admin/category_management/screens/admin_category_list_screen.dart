import 'package:dewmii/features/admin/category_management/screens/admin_edit_category_screen.dart';
import 'package:dewmii/shared/widgets/admin_navigation/admin_app_header.dart';
import 'package:flutter/material.dart';

import '../../../../app/routes.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_category_model.dart';
import '../services/admin_category_api_service.dart';
import '../widgets/admin_category_card.dart';

class AdminCategoryListScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const AdminCategoryListScreen({super.key, this.showCommonScaffold = true});

  @override
  State<AdminCategoryListScreen> createState() =>
      _AdminCategoryListScreenState();
}

class _AdminCategoryListScreenState extends State<AdminCategoryListScreen>
    with SingleTickerProviderStateMixin {
  final AdminCategoryApiService service = AdminCategoryApiService();
  final searchController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fade;

  bool isLoading = true;
  bool isActionLoading = false;

  List<AdminCategoryModel> categories = [];
  List<AdminCategoryModel> filteredCategories = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    fetchCategories();
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchCategories() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getCategories();

      if (!mounted) return;

      setState(() {
        categories = result;
        filteredCategories = _filter(result, searchController.text);
      });
      _controller.forward(from: 0);
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

  List<AdminCategoryModel> _filter(
    List<AdminCategoryModel> source,
    String value,
  ) {
    final keyword = value.trim().toLowerCase();
    if (keyword.isEmpty) return source;

    return source.where((category) {
      return category.name.toLowerCase().contains(keyword) ||
          category.slug.toLowerCase().contains(keyword) ||
          category.description.toLowerCase().contains(keyword) ||
          category.status.toLowerCase().contains(keyword);
    }).toList();
  }

  void searchCategories(String value) {
    setState(() => filteredCategories = _filter(categories, value));
  }

  Future<void> openAddCategory() async {
    final addedCategory = await Navigator.pushNamed(
      context,
      AppRoutes.adminAddCategory,
    );

    if (addedCategory is AdminCategoryModel) {
      setState(() {
        categories = [addedCategory, ...categories];
        filteredCategories = _filter(categories, searchController.text);
      });
    } else {
      fetchCategories();
    }
  }

  Future<void> openEditCategory(AdminCategoryModel category) async {
    final updatedCategory = await Navigator.push<AdminCategoryModel>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) =>
            AdminEditCategoryScreen(category: category),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: animation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
    );

    if (updatedCategory != null) {
      setState(() {
        categories = categories.map((item) {
          return item.id == category.id ? updatedCategory : item;
        }).toList();
        filteredCategories = _filter(categories, searchController.text);
      });
    }
  }

  Future<void> deleteCategory(AdminCategoryModel category) async {
    final shouldDelete = await _confirmDelete(category);
    if (shouldDelete != true) return;

    setState(() => isActionLoading = true);

    try {
      final response = await service.deleteCategory(categoryId: category.id);
      final deletedId = service.parseDeletedCategoryId(response) ?? category.id;

      if (!mounted) return;

      setState(() {
        categories = categories.where((item) => item.id != deletedId).toList();
        filteredCategories = _filter(categories, searchController.text);
      });

      AppToast.show(
        context,
        message:
            response['message']?.toString() ?? 'Category deleted successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<bool?> _confirmDelete(AdminCategoryModel category) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                    size: 30,
                  ),
                ),
                const SizedBox(height: 14),
                const Text(
                  'Delete Category?',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to delete ${category.name}? This action cannot be undone.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          backgroundColor: AppColors.error,
                        ),
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppHeader(
        title: 'Categories',
        subtitle: 'Create and manage product categories',
        showBackButton: widget.showCommonScaffold,
        extraActions: [
          IconButton(
            onPressed: openAddCategory,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddCategory,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Category'),
      ),
      body: isLoading
          ? const _CategorySkeleton()
          : RefreshIndicator(
              onRefresh: fetchCategories,
              child: FadeTransition(
                opacity: _fade,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                  children: [
                    if (isActionLoading) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 14),
                    ],
                    _CategoryHero(categories: categories),
                    const SizedBox(height: 18),
                    TextField(
                      controller: searchController,
                      onChanged: searchCategories,
                      decoration: InputDecoration(
                        hintText: 'Search categories',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  searchCategories('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Categories',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        _CountPill(count: filteredCategories.length),
                      ],
                    ),
                    const SizedBox(height: 14),
                    if (filteredCategories.isEmpty)
                      _EmptyCategories(
                        hasSearch: searchController.text.trim().isNotEmpty,
                        onAdd: openAddCategory,
                      )
                    else
                      ...filteredCategories.map((category) {
                        return AdminCategoryCard(
                          category: category,
                          onEdit: () => openEditCategory(category),
                          onDelete: () => deleteCategory(category),
                        );
                      }),
                  ],
                ),
              ),
            ),
    );
  }
}

class _CategoryHero extends StatelessWidget {
  final List<AdminCategoryModel> categories;

  const _CategoryHero({required this.categories});

  @override
  Widget build(BuildContext context) {
    final active = categories.where((item) => item.isActive).length;
    final inactive = categories.length - active;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.category_rounded, color: Colors.white),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Catalog Categories',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(
                  label: 'Total',
                  value: '${categories.length}',
                ),
              ),
              Expanded(
                child: _HeroMetric(label: 'Active', value: '$active'),
              ),
              Expanded(
                child: _HeroMetric(label: 'Inactive', value: '$inactive'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _CountPill extends StatelessWidget {
  final int count;

  const _CountPill({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        '$count items',
        style: const TextStyle(
          color: AppColors.primary,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _EmptyCategories extends StatelessWidget {
  final bool hasSearch;
  final VoidCallback onAdd;

  const _EmptyCategories({required this.hasSearch, required this.onAdd});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 70),
      child: Center(
        child: Column(
          children: [
            const Icon(
              Icons.category_outlined,
              size: 68,
              color: AppColors.primary,
            ),
            const SizedBox(height: 14),
            Text(
              hasSearch ? 'No matching categories' : 'No categories yet',
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              hasSearch
                  ? 'Try another keyword or clear the search field.'
                  : 'Create your first category to organize products.',
              textAlign: TextAlign.center,
            ),
            if (!hasSearch) ...[
              const SizedBox(height: 18),
              FilledButton.icon(
                onPressed: onAdd,
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add Category'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        7,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: index == 0 ? 170 : 92,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(index == 0 ? 30 : 24),
          ),
        ),
      ),
    );
  }
}
