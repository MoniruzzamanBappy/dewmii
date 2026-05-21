import 'package:dewmii/shared/widgets/admin_navigation/admin_app_header.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_product_model.dart';
import '../services/admin_product_api_service.dart';
import '../widgets/admin_product_card.dart';
import 'admin_add_product_screen.dart';
import 'admin_edit_product_screen.dart';
import 'admin_product_stock_screen.dart';

class AdminProductManagementScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const AdminProductManagementScreen({
    super.key,
    this.showCommonScaffold = true,
  });

  @override
  State<AdminProductManagementScreen> createState() =>
      _AdminProductManagementScreenState();
}

class _AdminProductManagementScreenState
    extends State<AdminProductManagementScreen>
    with SingleTickerProviderStateMixin {
  final AdminProductApiService service = AdminProductApiService();
  final searchController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fade;

  bool isLoading = true;
  bool isActionLoading = false;

  List<AdminProductModel> products = [];
  List<AdminProductModel> filteredProducts = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    searchController.addListener(filterProducts);
    fetchProducts();
  }

  @override
  void dispose() {
    searchController
      ..removeListener(filterProducts)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchProducts() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getProducts();

      if (!mounted) return;

      setState(() {
        products = result;
        filteredProducts = result;
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

  void filterProducts() {
    final query = searchController.text.trim().toLowerCase();

    setState(() {
      if (query.isEmpty) {
        filteredProducts = products;
      } else {
        filteredProducts = products.where((product) {
          return product.name.toLowerCase().contains(query) ||
              product.sku.toLowerCase().contains(query) ||
              product.categoryName.toLowerCase().contains(query) ||
              product.brandName.toLowerCase().contains(query);
        }).toList();
      }
    });
  }

  Future<void> openAddProduct() async {
    final createdProduct = await Navigator.push<AdminProductModel>(
      context,
      _route(const AdminAddProductScreen()),
    );

    if (createdProduct == null) return;

    setState(() {
      products = [createdProduct, ...products];
      filteredProducts = products;
    });
  }

  Future<void> openEditProduct(AdminProductModel product) async {
    final updatedProduct = await Navigator.push<AdminProductModel>(
      context,
      _route(
        AdminEditProductScreen(productId: product.id, fallbackProduct: product),
      ),
    );

    if (updatedProduct == null) return;

    products = products
        .map((item) => item.id == updatedProduct.id ? updatedProduct : item)
        .toList();
    filterProducts();
  }

  Future<void> openStock(AdminProductModel product) async {
    final updatedProduct = await Navigator.push<AdminProductModel>(
      context,
      _route(AdminProductStockScreen(product: product)),
    );

    if (updatedProduct == null) return;

    products = products
        .map((item) => item.id == updatedProduct.id ? updatedProduct : item)
        .toList();
    filterProducts();
  }

  Route<T> _route<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  Future<void> deleteProduct(AdminProductModel product) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.delete_outline_rounded,
                size: 54,
                color: AppColors.error,
              ),
              const SizedBox(height: 10),
              const Text(
                'Delete product?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              Text(
                product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),
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
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Delete'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );

    if (confirmed != true) return;

    setState(() => isActionLoading = true);

    try {
      final response = await service.deleteProductDemo(productId: product.id);
      final deletedId = service.parseDeletedProductId(response) ?? product.id;

      if (!mounted) return;

      setState(() {
        products.removeWhere((item) => item.id == deletedId);
        filteredProducts.removeWhere((item) => item.id == deletedId);
      });

      AppToast.show(
        context,
        message:
            response['message']?.toString() ?? 'Product deleted successfully',
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

  @override
  Widget build(BuildContext context) {
    final totalProducts = products.length;
    final activeProducts = products.where((item) => item.isActive).length;
    final lowStock = products.where((item) {
      return item.stockStatus == 'low_stock' || item.stock <= 10;
    }).length;

    return Scaffold(
      appBar: AdminAppHeader(
        title: 'Products',
        subtitle: 'Manage product list, stock and images',
        showBackButton: widget.showCommonScaffold,
        extraActions: [
          IconButton(
            onPressed: openAddProduct,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddProduct,
        icon: const Icon(Icons.add_rounded),
        label: const Text('Add Product'),
      ),
      body: isLoading
          ? const _ProductSkeleton()
          : RefreshIndicator(
              onRefresh: fetchProducts,
              child: FadeTransition(
                opacity: _fade,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
                  children: [
                    _ProductHero(
                      totalProducts: totalProducts,
                      activeProducts: activeProducts,
                      lowStock: lowStock,
                      isActionLoading: isActionLoading,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        hintText: 'Search products, SKU, category or brand',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () => searchController.clear(),
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 18),
                    if (filteredProducts.isEmpty)
                      const _EmptyProducts()
                    else
                      ...filteredProducts.map(
                        (product) => AdminProductCard(
                          product: product,
                          onEdit: () => openEditProduct(product),
                          onStock: () => openStock(product),
                          onDelete: () => deleteProduct(product),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _ProductHero extends StatelessWidget {
  final int totalProducts;
  final int activeProducts;
  final int lowStock;
  final bool isActionLoading;

  const _ProductHero({
    required this.totalProducts,
    required this.activeProducts,
    required this.lowStock,
    required this.isActionLoading,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const CircleAvatar(
                radius: 24,
                backgroundColor: Colors.white24,
                foregroundColor: Colors.white,
                child: Icon(Icons.inventory_2_rounded),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Manage catalog, inventory and product visibility',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    height: 1.25,
                  ),
                ),
              ),
              if (isActionLoading)
                const SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _HeroMetric(label: 'Total', value: '$totalProducts'),
              ),
              Expanded(
                child: _HeroMetric(label: 'Active', value: '$activeProducts'),
              ),
              Expanded(
                child: _HeroMetric(label: 'Low stock', value: '$lowStock'),
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
            fontSize: 21,
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

class _EmptyProducts extends StatelessWidget {
  const _EmptyProducts();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 48),
      child: Column(
        children: [
          Icon(Icons.inventory_2_outlined, size: 72, color: AppColors.primary),
          SizedBox(height: 12),
          Text(
            'No products found',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          SizedBox(height: 6),
          Text('Try another search or add a new product.'),
        ],
      ),
    );
  }
}

class _ProductSkeleton extends StatelessWidget {
  const _ProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        7,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: index == 0 ? 160 : 130,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(index == 0 ? 32 : 24),
          ),
        ),
      ),
    );
  }
}
