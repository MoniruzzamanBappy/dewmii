import 'package:dewmii/features/cart/services/cart_api_service.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/product_detail_model.dart';
import '../models/product_stock_model.dart';
import '../models/product_review_model.dart';
import '../services/product_api_service.dart';
import '../widgets/product_rating_summary.dart';
import '../widgets/related_products_section.dart';
import 'product_image_gallery_screen.dart';
import 'product_reviews_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final int productId;

  const ProductDetailsScreen({super.key, required this.productId});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  final ProductApiService service = ProductApiService();
  final CartApiService cartService = CartApiService();

  bool isLoading = true;
  bool isAddingCart = false;
  bool localWishlist = false;
  ProductDetailModel? product;
  ProductStockModel? stock;
  ProductVariantModel? selectedVariant;
  int selectedImageIndex = 0;
  int quantity = 1;

  Future<void> fetchProductDetails() async {
    setState(() => isLoading = true);
    try {
      final detail = await service.getProductDetails(widget.productId);
      final stockResult = await service.checkStock(widget.productId);
      if (!mounted) return;
      setState(() {
        product = detail;
        stock = stockResult;
        selectedVariant = detail?.variants.isNotEmpty == true ? detail!.variants.first : null;
        localWishlist = detail?.isWishlist ?? false;
      });
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> addToCart() async {
    final item = product;
    if (item == null) return;
    final currentStock = stock;
    if (currentStock != null && !currentStock.isAvailable) {
      AppToast.show(context, message: 'Product is not available', type: ToastType.error);
      return;
    }

    setState(() => isAddingCart = true);
    try {
      final result = await cartService.addItemDemo(productId: item.id, variantId: selectedVariant?.id, quantity: quantity);
      if (!mounted) return;
      AppToast.show(context, message: result['message']?.toString() ?? 'Added to cart', type: ToastType.success);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isAddingCart = false);
    }
  }

  void openGallery(List<String> images, int index) {
    Navigator.push(context, MaterialPageRoute(builder: (_) => ProductImageGalleryScreen(images: images, initialIndex: index)));
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: product == null || isLoading ? null : _BottomCartBar(
        product: product!,
        selectedVariant: selectedVariant,
        quantity: quantity,
        isLoading: isAddingCart,
        onDecrease: () => setState(() => quantity = quantity > 1 ? quantity - 1 : 1),
        onIncrease: () {
          final max = stock?.maxOrderQuantity ?? selectedVariant?.stock ?? product?.stock ?? 99;
          if (quantity < max) setState(() => quantity++);
        },
        onAddToCart: addToCart,
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 250),
        child: isLoading
            ? const _ProductDetailsSkeleton(key: ValueKey('loading'))
            : product == null
                ? _ProductNotFound(key: const ValueKey('empty'), onRetry: fetchProductDetails)
                : _ProductContent(
                    key: const ValueKey('content'),
                    product: product!,
                    stock: stock,
                    selectedImageIndex: selectedImageIndex,
                    selectedVariant: selectedVariant,
                    isWishlist: localWishlist,
                    onBack: () => Navigator.pop(context),
                    onShare: () => AppToast.show(context, message: 'Share option coming soon', type: ToastType.info),
                    onWishlist: () {
                      setState(() => localWishlist = !localWishlist);
                      AppToast.show(
                        context,
                        message: localWishlist ? 'Added to wishlist' : 'Removed from wishlist',
                        type: ToastType.success,
                      );
                    },
                    onImageTap: (index) => openGallery(product!.imageUrls, index),
                    onImageChanged: (index) => setState(() => selectedImageIndex = index),
                    onVariantChanged: (variant) => setState(() => selectedVariant = variant),
                  ),
      ),
    );
  }
}

class _ProductContent extends StatelessWidget {
  final ProductDetailModel product;
  final ProductStockModel? stock;
  final int selectedImageIndex;
  final ProductVariantModel? selectedVariant;
  final bool isWishlist;
  final VoidCallback onBack;
  final VoidCallback onShare;
  final VoidCallback onWishlist;
  final ValueChanged<int> onImageTap;
  final ValueChanged<int> onImageChanged;
  final ValueChanged<ProductVariantModel> onVariantChanged;

  const _ProductContent({
    super.key,
    required this.product,
    required this.stock,
    required this.selectedImageIndex,
    required this.selectedVariant,
    required this.isWishlist,
    required this.onBack,
    required this.onShare,
    required this.onWishlist,
    required this.onImageTap,
    required this.onImageChanged,
    required this.onVariantChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final images = product.imageUrls.where((url) => url.isNotEmpty).toList();
    final safeImageIndex = selectedImageIndex.clamp(0, images.isEmpty ? 0 : images.length - 1);

    return RefreshIndicator(
      onRefresh: () async {},
      child: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 390,
            pinned: true,
            stretch: true,
            leading: _RoundIconButton(icon: Icons.arrow_back_rounded, onTap: onBack),
            actions: [
              _RoundIconButton(icon: Icons.ios_share_rounded, onTap: onShare),
              const SizedBox(width: 8),
              _RoundIconButton(icon: isWishlist ? Icons.favorite_rounded : Icons.favorite_border_rounded, onTap: onWishlist, color: isWishlist ? AppColors.error : null),
              const SizedBox(width: 12),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (images.isEmpty)
                    Container(
                      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                      child: const Icon(Icons.image_rounded, size: 96, color: Colors.white70),
                    )
                  else
                    GestureDetector(
                      onTap: () => onImageTap(safeImageIndex),
                      child: Hero(
                        tag: 'product-image-${images[safeImageIndex]}',
                        child: Image.network(
                          images[safeImageIndex],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Container(
                            decoration: const BoxDecoration(gradient: AppColors.heroGradient),
                            child: const Icon(Icons.broken_image_rounded, size: 82, color: Colors.white70),
                          ),
                        ),
                      ),
                    ),
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [Colors.black54, Colors.transparent, Colors.black54],
                      ),
                    ),
                  ),
                  if (product.hasDiscount)
                    Positioned(
                      left: 18,
                      bottom: 74,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.error, borderRadius: BorderRadius.circular(999)),
                        child: Text('${product.discountPercentage}% OFF', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                      ),
                    ),
                  if (images.length > 1)
                    Positioned(
                      left: 18,
                      right: 18,
                      bottom: 16,
                      child: SizedBox(
                        height: 48,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          separatorBuilder: (_, __) => const SizedBox(width: 10),
                          itemBuilder: (context, index) {
                            final selected = index == safeImageIndex;
                            return GestureDetector(
                              onTap: () => onImageChanged(index),
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 220),
                                width: selected ? 62 : 48,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(color: selected ? Colors.white : Colors.white38, width: selected ? 2 : 1),
                                  image: DecorationImage(image: NetworkImage(images[index]), fit: BoxFit.cover),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(18, 20, 18, 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _BrandCategoryRow(product: product),
                  const SizedBox(height: 12),
                  Text(product.name, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, height: 1.15)),
                  if (product.shortDescription.isNotEmpty) ...[
                    const SizedBox(height: 10),
                    Text(product.shortDescription, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant, height: 1.45)),
                  ],
                  const SizedBox(height: 16),
                  _PriceRatingRow(product: product, stock: stock),
                  if (product.variants.isNotEmpty) ...[
                    const SizedBox(height: 22),
                    _SectionTitle(title: 'Choose option'),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: product.variants.map((variant) {
                        final selected = selectedVariant?.id == variant.id;
                        return ChoiceChip(
                          selected: selected,
                          label: Text(variant.name),
                          avatar: variant.colorCode == null || variant.colorCode!.isEmpty
                              ? null
                              : CircleAvatar(backgroundColor: _parseColor(variant.colorCode!), radius: 8),
                          onSelected: (_) => onVariantChanged(variant),
                          labelStyle: TextStyle(fontWeight: FontWeight.w800, color: selected ? Colors.white : null),
                          selectedColor: AppColors.primary,
                          backgroundColor: theme.colorScheme.surface,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999), side: BorderSide(color: theme.colorScheme.outlineVariant)),
                        );
                      }).toList(),
                    ),
                  ],
                  const SizedBox(height: 22),
                  _InfoTiles(product: product, stock: stock),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Description'),
                    const SizedBox(height: 10),
                    Text(product.description, style: theme.textTheme.bodyMedium?.copyWith(height: 1.55, color: theme.colorScheme.onSurfaceVariant)),
                  ],
                  if (product.specifications.isNotEmpty) ...[
                    const SizedBox(height: 24),
                    _SectionTitle(title: 'Specifications'),
                    const SizedBox(height: 10),
                    _SpecificationCard(specifications: product.specifications),
                  ],
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: _SectionTitle(title: 'Ratings & Reviews')),
                      TextButton(
                        onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => ProductReviewsScreen(productId: product.id))),
                        child: const Text('View all'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  ProductRatingSummary(
                    summary: product.reviewSummary.totalReviews == 0 && product.totalReviews > 0
                        ? ProductReviewSummaryModelLike.toReviewModel(product.rating, product.totalReviews)
                        : ProductReviewSummaryModelLike.fromDetail(product.reviewSummary),
                  ),
                  const SizedBox(height: 26),
                  RelatedProductsSection(productId: product.id),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _parseColor(String value) {
    final normalized = value.replaceAll('#', '').trim();
    try {
      if (normalized.length == 6) return Color(int.parse('FF$normalized', radix: 16));
      if (normalized.length == 8) return Color(int.parse(normalized, radix: 16));
    } catch (_) {}
    return AppColors.primary;
  }
}

class ProductReviewSummaryModelLike {
  static ProductReviewSummaryModel fromDetail(ProductReviewSummary summary) {
    return ProductReviewSummaryModel(
      averageRating: summary.averageRating,
      totalReviews: summary.totalReviews,
      ratingCount: summary.ratingCount,
    );
  }

  static ProductReviewSummaryModel toReviewModel(num rating, int totalReviews) {
    return ProductReviewSummaryModel(
      averageRating: rating,
      totalReviews: totalReviews,
      ratingCount: const <String, dynamic>{},
    );
  }
}

class _BrandCategoryRow extends StatelessWidget {
  final ProductDetailModel product;
  const _BrandCategoryRow({required this.product});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        if (product.brand.name.isNotEmpty) _Pill(icon: Icons.verified_rounded, label: product.brand.name),
        if (product.category.name.isNotEmpty) _Pill(icon: Icons.category_rounded, label: product.category.name),
        if (product.sku.isNotEmpty) _Pill(icon: Icons.qr_code_rounded, label: product.sku, color: scheme.secondaryContainer),
      ],
    );
  }
}

class _Pill extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? color;
  const _Pill({required this.icon, required this.label, this.color});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(color: color ?? AppColors.primary.withOpacity(.12), borderRadius: BorderRadius.circular(999)),
      child: Row(mainAxisSize: MainAxisSize.min, children: [
        Icon(icon, size: 15, color: color == null ? AppColors.primary : scheme.onSecondaryContainer),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: color == null ? AppColors.primary : scheme.onSecondaryContainer)),
      ]),
    );
  }
}

class _PriceRatingRow extends StatelessWidget {
  final ProductDetailModel product;
  final ProductStockModel? stock;
  const _PriceRatingRow({required this.product, required this.stock});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final isAvailable = stock?.isAvailable ?? product.inStock;
    return Row(
      children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Text('৳${product.displayPrice}', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900, color: AppColors.primary)),
              if (product.hasDiscount) ...[
                const SizedBox(width: 8),
                Text('৳${product.price}', style: theme.textTheme.bodyMedium?.copyWith(decoration: TextDecoration.lineThrough, color: scheme.onSurfaceVariant)),
              ],
            ]),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.star_rounded, size: 20, color: AppColors.warning),
              const SizedBox(width: 4),
              Text('${product.rating}', style: const TextStyle(fontWeight: FontWeight.w900)),
              Text(' (${product.totalReviews} reviews)', style: TextStyle(color: scheme.onSurfaceVariant)),
            ]),
          ]),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.success.withOpacity(.12) : AppColors.error.withOpacity(.12),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(isAvailable ? 'In stock' : 'Out of stock', style: TextStyle(color: isAvailable ? AppColors.success : AppColors.error, fontWeight: FontWeight.w900)),
        ),
      ],
    );
  }
}

class _InfoTiles extends StatelessWidget {
  final ProductDetailModel product;
  final ProductStockModel? stock;
  const _InfoTiles({required this.product, required this.stock});

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _InfoTile(icon: Icons.inventory_2_rounded, title: '${stock?.availableStock ?? product.stock}', subtitle: 'Available')),
      const SizedBox(width: 10),
      const Expanded(child: _InfoTile(icon: Icons.local_shipping_rounded, title: 'Fast', subtitle: 'Delivery')),
      const SizedBox(width: 10),
      const Expanded(child: _InfoTile(icon: Icons.verified_user_rounded, title: 'Safe', subtitle: 'Checkout')),
    ]);
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const _InfoTile({required this.icon, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(20), border: Border.all(color: scheme.outlineVariant.withOpacity(.55))),
      child: Column(children: [
        Icon(icon, color: AppColors.primary),
        const SizedBox(height: 8),
        Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)),
        const SizedBox(height: 2),
        Text(subtitle, style: TextStyle(fontSize: 12, color: scheme.onSurfaceVariant)),
      ]),
    );
  }
}

class _SpecificationCard extends StatelessWidget {
  final List<ProductSpecificationModel> specifications;
  const _SpecificationCard({required this.specifications});

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: scheme.outlineVariant.withOpacity(.55))),
      child: Column(
        children: List.generate(specifications.length, (index) {
          final spec = specifications[index];
          return Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(border: Border(top: index == 0 ? BorderSide.none : BorderSide(color: scheme.outlineVariant.withOpacity(.35)))),
            child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(child: Text(spec.name, style: TextStyle(color: scheme.onSurfaceVariant, fontWeight: FontWeight.w700))),
              const SizedBox(width: 12),
              Expanded(child: Text(spec.value, textAlign: TextAlign.end, style: const TextStyle(fontWeight: FontWeight.w900))),
            ]),
          );
        }),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900));
  }
}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  const _RoundIconButton({required this.icon, required this.onTap, this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 8),
      child: Material(
        color: Colors.black.withOpacity(.28),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(width: 42, height: 42, child: Icon(icon, color: color ?? Colors.white)),
        ),
      ),
    );
  }
}

class _BottomCartBar extends StatelessWidget {
  final ProductDetailModel product;
  final ProductVariantModel? selectedVariant;
  final int quantity;
  final bool isLoading;
  final VoidCallback onDecrease;
  final VoidCallback onIncrease;
  final VoidCallback onAddToCart;

  const _BottomCartBar({
    required this.product,
    required this.selectedVariant,
    required this.quantity,
    required this.isLoading,
    required this.onDecrease,
    required this.onIncrease,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final unitPrice = selectedVariant?.price == 0 || selectedVariant == null ? product.displayPrice : selectedVariant!.price;
    final total = unitPrice * quantity;

    return Container(
      padding: const EdgeInsets.fromLTRB(18, 12, 18, 18),
      decoration: BoxDecoration(
        color: scheme.surface,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(.08), blurRadius: 24, offset: const Offset(0, -10))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: SafeArea(
        top: false,
        child: Row(children: [
          Container(
            decoration: BoxDecoration(color: scheme.surfaceContainerHighest, borderRadius: BorderRadius.circular(18)),
            child: Row(children: [
              IconButton(onPressed: onDecrease, icon: const Icon(Icons.remove_rounded)),
              Text('$quantity', style: const TextStyle(fontWeight: FontWeight.w900)),
              IconButton(onPressed: onIncrease, icon: const Icon(Icons.add_rounded)),
            ]),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: FilledButton(
              onPressed: isLoading ? null : onAddToCart,
              style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
              child: isLoading
                  ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                  : Text('Add to Cart · ৳$total', style: const TextStyle(fontWeight: FontWeight.w900)),
            ),
          ),
        ]),
      ),
    );
  }
}

class _ProductDetailsSkeleton extends StatelessWidget {
  const _ProductDetailsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        Container(height: 390, color: color),
        Padding(
          padding: const EdgeInsets.all(18),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 130, height: 24, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 14),
            Container(width: double.infinity, height: 32, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(12))),
            const SizedBox(height: 12),
            Container(width: 260, height: 18, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999))),
            const SizedBox(height: 22),
            Row(children: List.generate(3, (index) => Expanded(child: Container(height: 92, margin: EdgeInsets.only(right: index == 2 ? 0 : 10), decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(20))))),),
          ]),
        ),
      ],
    );
  }
}

class _ProductNotFound extends StatelessWidget {
  final VoidCallback onRetry;
  const _ProductNotFound({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.search_off_rounded, size: 84, color: theme.colorScheme.primary.withOpacity(.35)),
          const SizedBox(height: 18),
          Text('Product not found', style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text('We could not load this product right now.', textAlign: TextAlign.center, style: TextStyle(color: theme.colorScheme.onSurfaceVariant)),
          const SizedBox(height: 20),
          FilledButton.icon(onPressed: onRetry, icon: const Icon(Icons.refresh_rounded), label: const Text('Try again')),
        ]),
      ),
    );
  }
}
