import 'package:dewmii/features/address/screens/address_list_screen.dart';
import 'package:dewmii/features/cart/screens/cart_screen.dart';
import 'package:dewmii/features/notifications/screens/notification_list_screen.dart';
import 'package:dewmii/features/order/screens/my_orders_screen.dart';
import 'package:dewmii/features/profile/screens/profile_screen.dart';
import 'package:dewmii/features/support/screens/help_center_screen.dart';
import 'package:dewmii/features/wishlist/screens/wishlist_screen.dart';
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
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DiscoveryApiService discoveryService = DiscoveryApiService();

  bool isLoading = true;
  HomeDataModel? homeData;

  Future<void> fetchHome() async {
    setState(() {
      isLoading = true;
    });

    try {
      final data = await discoveryService.getHomeData();

      if (!mounted) return;

      setState(() {
        homeData = data;
      });
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
      appBar: AppBar(
        title: const Text('Dewmii'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
              );
            },
            icon: const Icon(Icons.help_outline_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ProfileScreen()),
              );
            },
            icon: const Icon(Icons.person_outline_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const MyOrdersScreen()),
              );
            },
            icon: const Icon(Icons.receipt_long_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AddressListScreen()),
              );
            },
            icon: const Icon(Icons.location_on_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const WishlistScreen()),
              );
            },
            icon: const Icon(Icons.favorite_border_rounded),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CartScreen()),
              );
            },
            icon: const Icon(Icons.shopping_cart_outlined),
          ),
          IconButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SearchScreen()),
              );
            },
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(onPressed: logout, icon: const Icon(Icons.logout_rounded)),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchHome,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : data == null
            ? ListView(
                padding: const EdgeInsets.all(24),
                children: const [Center(child: Text('No home data found'))],
              )
            : ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const SearchScreen()),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.lightSurface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: AppColors.lightBorder),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search_rounded, color: AppColors.muted),
                          SizedBox(width: 12),
                          Text(
                            'Search products...',
                            style: TextStyle(
                              color: AppColors.lightTextSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  SizedBox(
                    height: 170,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.banners.length,
                      itemBuilder: (context, index) {
                        final banner = data.banners[index];

                        return BannerCard(
                          banner: banner,
                          onTap: () {
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
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Categories',
                    actionText: 'View All',
                    onActionTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const CategoryListScreen(),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 112,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: data.categories.length,
                      itemBuilder: (context, index) {
                        final category = data.categories[index];

                        return CategoryCard(
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
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Featured Products',
                    actionText: 'View All',
                    onActionTap: () {
                      openProducts('Featured Products', data.featuredProducts);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ProductGrid(products: data.featuredProducts),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'New Arrivals',
                    actionText: 'View All',
                    onActionTap: () {
                      openProducts('New Arrivals', data.newArrivals);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ProductGrid(products: data.newArrivals),
                  const SizedBox(height: 24),
                  SectionHeader(
                    title: 'Best Selling',
                    actionText: 'View All',
                    onActionTap: () {
                      openProducts('Best Selling', data.bestSelling);
                    },
                  ),
                  const SizedBox(height: 12),
                  _ProductGrid(products: data.bestSelling),
                ],
              ),
      ),
    );
  }
}

class _ProductGrid extends StatelessWidget {
  final List<ProductModel> products;

  const _ProductGrid({required this.products});

  @override
  Widget build(BuildContext context) {
    if (products.isEmpty) {
      return const Text('No products found');
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14,
        mainAxisSpacing: 14,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return ProductCard(product: products[index]);
      },
    );
  }
}
