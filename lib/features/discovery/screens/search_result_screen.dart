import 'package:dewmii/features/discovery/screens/filter_sort_screen.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/product_model.dart';
import '../services/discovery_api_service.dart';
import '../widgets/product_card.dart';

class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({super.key, required this.query});

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final DiscoveryApiService service = DiscoveryApiService();

  bool isLoading = true;
  List<ProductModel> products = [];

  Future<void> search() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.searchProducts(widget.query);

      if (!mounted) return;

      setState(() {
        products = result;
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

  Future<void> openFilter() async {
    final filtered = await Navigator.push<List<ProductModel>>(
      context,
      MaterialPageRoute(builder: (_) => FilterSortScreen(query: widget.query)),
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
    search();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Results for "${widget.query}"'),
        actions: [
          IconButton(
            onPressed: openFilter,
            icon: const Icon(Icons.tune_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : products.isEmpty
          ? const Center(child: Text('No products found'))
          : GridView.builder(
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
            ),
    );
  }
}
