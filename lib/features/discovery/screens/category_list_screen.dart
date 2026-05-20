import 'package:dewmii/features/discovery/screens/subcategory_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/category_model.dart';
import '../services/discovery_api_service.dart';
import '../widgets/category_card.dart';

class CategoryListScreen extends StatefulWidget {
  const CategoryListScreen({super.key});

  @override
  State<CategoryListScreen> createState() => _CategoryListScreenState();
}

class _CategoryListScreenState extends State<CategoryListScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  bool isLoading = true;
  List<CategoryModel> categories = [];

  Future<void> fetchCategories() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getCategories();
      if (!mounted) return;
      setState(() => categories = result);
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
  void initState() {
    super.initState();
    fetchCategories();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('All Categories')),
      body: RefreshIndicator(
        onRefresh: fetchCategories,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          child: isLoading
              ? const _CategorySkeleton(key: ValueKey('category-loading'))
              : categories.isEmpty
              ? const _EmptyCategories(key: ValueKey('category-empty'))
              : CustomScrollView(
                  key: const ValueKey('category-content'),
                  slivers: [
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                      sliver: SliverToBoxAdapter(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            gradient: theme.brightness == Brightness.dark
                                ? AppColors.darkHeroGradient
                                : AppColors.heroGradient,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Row(
                            children: [
                              const CircleAvatar(
                                radius: 26,
                                backgroundColor: Colors.white,
                                child: Icon(
                                  Icons.category_rounded,
                                  color: AppColors.primary,
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${categories.length} Categories',
                                      style: theme.textTheme.titleLarge
                                          ?.copyWith(
                                            fontWeight: FontWeight.w900,
                                          ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Explore curated product collections',
                                      style: theme.textTheme.bodyMedium
                                          ?.copyWith(
                                            color: theme
                                                .colorScheme
                                                .onSurfaceVariant,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.fromLTRB(20, 18, 20, 110),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              mainAxisSpacing: 18,
                              crossAxisSpacing: 12,
                              childAspectRatio: 0.74,
                            ),
                        delegate: SliverChildBuilderDelegate((context, index) {
                          final category = categories[index];
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 320 + index * 35),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) {
                              return Opacity(
                                opacity: value,
                                child: Transform.translate(
                                  offset: Offset(0, 16 * (1 - value)),
                                  child: child,
                                ),
                              );
                            },
                            child: CategoryCard(
                              category: category,
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) =>
                                        SubcategoryScreen(category: category),
                                  ),
                                );
                              },
                            ),
                          );
                        }, childCount: categories.length),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}

class _CategorySkeleton extends StatelessWidget {
  const _CategorySkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 12,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 18,
        crossAxisSpacing: 12,
        childAspectRatio: 0.74,
      ),
      itemBuilder: (_, _) => Container(
        decoration: BoxDecoration(
          color: AppColors.softMuted,
          borderRadius: BorderRadius.circular(24),
        ),
      ),
    );
  }
}

class _EmptyCategories extends StatelessWidget {
  const _EmptyCategories({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24),
      children: const [
        SizedBox(height: 120),
        Icon(Icons.category_outlined, size: 72, color: AppColors.primary),
        SizedBox(height: 14),
        Text(
          'No categories found',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
      ],
    );
  }
}
