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
      setState(() => products = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchRelated();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (isLoading) return const _RelatedSkeleton();
    if (products.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(child: Text('Related Products', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900))),
            Text('${products.length} items', style: theme.textTheme.bodySmall?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
          ],
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
            return TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: 1),
              duration: Duration(milliseconds: 260 + index * 60),
              curve: Curves.easeOutCubic,
              builder: (context, value, child) => Opacity(
                opacity: value,
                child: Transform.translate(offset: Offset(0, 18 * (1 - value)), child: child),
              ),
              child: ProductCard(
                product: product,
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ProductDetailsScreen(productId: product.id)),
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class _RelatedSkeleton extends StatelessWidget {
  const _RelatedSkeleton();

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(width: 170, height: 22, decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(999))),
        const SizedBox(height: 14),
        Row(
          children: List.generate(2, (index) => Expanded(
            child: Container(
              height: 220,
              margin: EdgeInsets.only(right: index == 0 ? 14 : 0),
              decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(24)),
            ),
          )),
        ),
      ],
    );
  }
}
