import 'package:dewmii/features/product/screens/product_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../../discovery/models/product_model.dart';
import '../../discovery/widgets/product_card.dart';
import '../services/product_api_service.dart';

class RelatedProductsSection extends StatefulWidget {
  final int productId;

  const RelatedProductsSection({super.key, required this.productId});

  @override
  State<RelatedProductsSection> createState() => _RelatedProductsSectionState();
}

class _RelatedProductsSectionState extends State<RelatedProductsSection> {
  final ProductApiService service = ProductApiService();

  bool isLoading = true;
  List<ProductModel> products = [];

  Future<void> fetchRelated() async {
    try {
      final result = await service.getRelatedProducts(widget.productId);

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

  @override
  void initState() {
    super.initState();
    fetchRelated();
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (products.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Related Products',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 14),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 14,
            crossAxisSpacing: 14,
            childAspectRatio: 0.72,
          ),
          itemBuilder: (context, index) {
            final product = products[index];

            return ProductCard(
              product: product,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProductDetailsScreen(productId: product.id),
                  ),
                );
              },
            );
          },
        ),
      ],
    );
  }
}
