import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/product_model.dart';
import '../services/discovery_api_service.dart';
import '../widgets/product_card.dart';
import 'filter_sort_screen.dart';
import 'search_screen.dart';

class ProductListingScreen extends StatefulWidget {
  final String title;
  final int? categoryId;
  final List<ProductModel>? initialProducts;

  const ProductListingScreen({
    super.key,
    required this.title,
    this.categoryId,
    this.initialProducts,
  });

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  bool isLoading = true;
  bool isGrid = true;

  List<ProductModel> products = [];

  Future<void> fetchProducts() async {
    setState(() {
      isLoading = true;
    });

    try {
      if (widget.initialProducts != null) {
        products = widget.initialProducts!;
      } else if (widget.categoryId != null) {
        products = await service.getProductsByCategory(widget.categoryId!);
      } else {
        products = await service.getProducts();
      }

      if (!mounted) return;

      setState(() {});
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

  Future<void> openFilter() async {
    final filtered = await Navigator.push<List<ProductModel>>(
      context,
      MaterialPageRoute(
        builder: (_) => FilterSortScreen(categoryId: widget.categoryId),
      ),
    );

    if (filtered != null) {
      setState(() {
        products = filtered;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGrid = !isGrid;
              });
            },
            icon: Icon(
              isGrid ? Icons.view_list_rounded : Icons.grid_view_rounded,
            ),
          ),
          IconButton(
            onPressed: openFilter,
            icon: const Icon(Icons.tune_rounded),
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
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('No products found'))
          : isGrid
          ? GridView.builder(
              padding: const EdgeInsets.all(20),
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
            )
          : ListView.separated(
              padding: const EdgeInsets.all(20),
              itemCount: products.length,
              separatorBuilder: (_, _) {
                return const SizedBox(height: 14);
              },
              itemBuilder: (context, index) {
                final product = products[index];

                return SizedBox(
                  height: 220,
                  child: ProductCard(product: product),
                );
              },
            ),
    );
  }
}
