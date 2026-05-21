import 'package:dewmii/shared/widgets/navigation/common_app_header.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../shared/widgets/app_toast.dart';
import '../auth/screens/login_screen.dart';
import '../auth/services/auth_api_service.dart';
import '../discovery/models/home_data_model.dart';
import '../discovery/models/product_model.dart';
import '../discovery/screens/category_list_screen.dart';
import '../discovery/screens/product_listing_screen.dart';
import '../discovery/screens/search_screen.dart';
import '../discovery/screens/subcategory_screen.dart';
import '../discovery/services/discovery_api_service.dart';
import '../discovery/widgets/banner_card.dart';
import '../discovery/widgets/category_card.dart';
import '../discovery/widgets/product_card.dart';
import '../discovery/widgets/section_header.dart';

class HomeScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const HomeScreen({super.key, this.showCommonScaffold = true});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DiscoveryApiService discoveryService = DiscoveryApiService();

  bool isLoading = true;
  HomeDataModel? homeData;

  Future<void> fetchHome() async {
    if (mounted) setState(() => isLoading = true);

    try {
      final data = await discoveryService.getHomeData();
      if (!mounted) return;
      setState(() => homeData = data);
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

  Future<void> logout() async {
    try {
      final service = AuthApiService();
      final response = await service.logout();

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Logout successful',
        type: ToastType.success,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
      );
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    }
  }

  void openProducts(String title, List<ProductModel> products) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductListingScreen(title: title, initialProducts: products),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchHome();
  }

  @override
  Widget build(BuildContext context) {
    final data = homeData;

    return Scaffold(
      appBar: const CommonAppHeader(title: 'Dewmii'),
      body: RefreshIndicator(
        onRefresh: fetchHome,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 320),
          switchInCurve: Curves.easeOutCubic,
          switchOutCurve: Curves.easeInCubic,
          child: isLoading
              ? const _HomeSkeleton(key: ValueKey('home-loading'))
              : data == null || data.isEmpty
              ? _EmptyState(
                  key: const ValueKey('home-empty'),
                  title: 'No home data found',
                  message:
                      'Pull down to refresh and try loading the latest products again.',
                  icon: Icons.storefront_rounded,
                  onAction: fetchHome,
                )
              : _HomeContent(
                  key: const ValueKey('home-content'),
                  data: data,
                  onSearchTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const SearchScreen()),
                    );
                  },
                  onCategoryViewAll: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => const CategoryListScreen(),
                      ),
                    );
                  },
                  onBannerTap: (banner) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ProductListingScreen(
                          title: banner.title,
                          categoryId: banner.redirectId,
                        ),
                      ),
                    );
                  },
                  onCategoryTap: (category) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => SubcategoryScreen(category: category),
                      ),
                    );
                  },
                  openProducts: openProducts,
                ),
        ),
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  final HomeDataModel data;
  final VoidCallback onSearchTap;
  final VoidCallback onCategoryViewAll;
  final void Function(dynamic banner) onBannerTap;
  final void Function(dynamic category) onCategoryTap;
  final void Function(String title, List<ProductModel> products) openProducts;

  const _HomeContent({
    super.key,
    required this.data,
    required this.onSearchTap,
    required this.onCategoryViewAll,
    required this.onBannerTap,
    required this.onCategoryTap,
    required this.openProducts,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        _HeroIntro(onSearchTap: onSearchTap),
        const SizedBox(height: 22),
        if (data.banners.isNotEmpty) ...[
          SizedBox(
            height: 186,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.none,
              itemCount: data.banners.length,
              itemBuilder: (context, index) {
                final banner = data.banners[index];
                return _FadeSlide(
                  delay: Duration(milliseconds: 60 * index),
                  child: BannerCard(
                    banner: banner,
                    onTap: () => onBannerTap(banner),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 28),
        ],
        SectionHeader(
          title: 'Categories',
          subtitle: 'Shop by your favorite collections',
          actionText: 'View All',
          onActionTap: onCategoryViewAll,
        ),
        const SizedBox(height: 14),
        SizedBox(
          height: 118,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            clipBehavior: Clip.none,
            itemCount: data.categories.length,
            itemBuilder: (context, index) {
              final category = data.categories[index];
              return _FadeSlide(
                delay: Duration(milliseconds: 45 * index),
                child: CategoryCard(
                  category: category,
                  onTap: () => onCategoryTap(category),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 28),
        _ProductSection(
          title: 'Featured Products',
          subtitle: 'Curated picks for you',
          products: data.featuredProducts,
          onViewAll: () =>
              openProducts('Featured Products', data.featuredProducts),
        ),
        _ProductSection(
          title: 'New Arrivals',
          subtitle: 'Fresh drops just landed',
          products: data.newArrivals,
          onViewAll: () => openProducts('New Arrivals', data.newArrivals),
        ),
        _ProductSection(
          title: 'Best Selling',
          subtitle: 'Loved by Dewmii customers',
          products: data.bestSelling,
          onViewAll: () => openProducts('Best Selling', data.bestSelling),
        ),
      ],
    );
  }
}

class _HeroIntro extends StatelessWidget {
  final VoidCallback onSearchTap;

  const _HeroIntro({required this.onSearchTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: theme.brightness == Brightness.dark
            ? AppColors.darkHeroGradient
            : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.72),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome_rounded,
                      size: 15,
                      color: AppColors.primary,
                    ),
                    SizedBox(width: 6),
                    Text(
                      'Modern shopping',
                      style: TextStyle(
                        fontWeight: FontWeight.w900,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            'Find your next favorite product',
            style: theme.textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              letterSpacing: -0.8,
              height: 1.05,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Search collections, browse categories, and explore trending deals.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.35,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          InkWell(
            onTap: onSearchTap,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
              decoration: BoxDecoration(
                color: theme.cardColor.withValues(alpha: 0.92),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: theme.dividerColor.withValues(alpha: 0.45),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search_rounded, color: AppColors.primary),
                  const SizedBox(width: 12),
                  Text(
                    'Search products, brands, categories...',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductSection extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<ProductModel> products;
  final VoidCallback onViewAll;

  const _ProductSection({
    required this.title,
    required this.subtitle,
    required this.products,
    required this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionHeader(
          title: title,
          subtitle: subtitle,
          actionText: 'View All',
          onActionTap: onViewAll,
        ),
        const SizedBox(height: 14),
        _ProductGrid(products: products),
        const SizedBox(height: 28),
      ],
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const _InlineEmpty(message: 'No products found');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length > 4 ? 4 : products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.68,
      ),
      itemBuilder: (context, index) {
        return _FadeSlide(
          delay: Duration(milliseconds: 55 * index),
          child: ProductCard(product: products[index]),
        );
      },
    );
  }
}

class _HomeSkeleton extends StatelessWidget {
  const _HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
      children: [
        const _SkeletonBox(height: 184, radius: 30),
        const SizedBox(height: 22),
        SizedBox(
          height: 186,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 3,
            separatorBuilder: (_, _) => const SizedBox(width: 16),
            itemBuilder: (_, _) =>
                const _SkeletonBox(width: 306, height: 186, radius: 30),
          ),
        ),
        const SizedBox(height: 28),
        const _SkeletonBox(width: 180, height: 24, radius: 12),
        const SizedBox(height: 14),
        SizedBox(
          height: 118,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: 5,
            separatorBuilder: (_, _) => const SizedBox(width: 12),
            itemBuilder: (_, _) =>
                const _SkeletonBox(width: 82, height: 100, radius: 24),
          ),
        ),
        const SizedBox(height: 28),
        const _SkeletonBox(width: 210, height: 24, radius: 12),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: 4,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 14,
            mainAxisSpacing: 14,
            childAspectRatio: 0.68,
          ),
          itemBuilder: (_, _) => const _SkeletonBox(radius: 24),
        ),
      ],
    );
  }
}

class _FadeSlide extends StatelessWidget {
  final Widget child;
  final Duration delay;

  const _FadeSlide({required this.child, this.delay = Duration.zero});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: Duration(milliseconds: 420 + delay.inMilliseconds),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: child,
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double? width;
  final double? height;
  final double radius;

  const _SkeletonBox({this.width, this.height, this.radius = 18});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.35, end: 1),
      duration: const Duration(milliseconds: 900),
      curve: Curves.easeInOut,
      builder: (context, value, _) {
        return Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: AppColors.softMuted.withValues(alpha: value),
            borderRadius: BorderRadius.circular(radius),
          ),
        );
      },
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  final String message;

  const _InlineEmpty({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: Theme.of(context).dividerColor.withValues(alpha: 0.55),
        ),
      ),
      child: Text(message, textAlign: TextAlign.center),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback onAction;

  const _EmptyState({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const SizedBox(height: 80),
        Icon(icon, size: 70, color: AppColors.primary),
        const SizedBox(height: 18),
        Text(
          title,
          textAlign: TextAlign.center,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: 22),
        ElevatedButton.icon(
          onPressed: onAction,
          icon: const Icon(Icons.refresh_rounded),
          label: const Text('Refresh'),
        ),
      ],
    );
  }
}
