import 'package:dewmii/features/cart/services/cart_api_service.dart';
import 'package:dewmii/features/wishlist/services/wishlist_api_service.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/product_detail_model.dart';
import '../models/product_stock_model.dart';
import '../services/product_api_service.dart';
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

  bool isLoading = true;
  ProductDetailModel? product;
  ProductStockModel? stock;

  int selectedImageIndex = 0;
  ProductVariantModel? selectedVariant;
  int quantity = 1;

  Future<void> fetchProductDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final detail = await service.getProductDetails(widget.productId);
      final stockResult = await service.checkStock(widget.productId);

      if (!mounted) return;

      setState(() {
        product = detail;
        stock = stockResult;

        if (detail != null && detail.variants.isNotEmpty) {
          selectedVariant = detail.variants.first;
        }
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

  void openGallery(List<String> images, int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            ProductImageGalleryScreen(images: images, initialIndex: index),
      ),
    );
  }

  Future<void> addToCartDemo() async {
    final currentStock = stock;

    if (currentStock != null && !currentStock.isAvailable) {
      AppToast.show(
        context,
        message: 'Product is not available',
        type: ToastType.error,
      );
      return;
    }

    try {
      final cartService = CartApiService();

      final response = await cartService.addItemDemo(
        productId: widget.productId,
        variantId: selectedVariant?.id,
        quantity: quantity,
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Product added to cart',
        type: ToastType.success,
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

  void buyNowDemo() {
    AppToast.show(
      context,
      message: 'Buy now demo action clicked',
      type: ToastType.info,
    );
  }

  @override
  void initState() {
    super.initState();
    fetchProductDetails();
  }

  @override
  Widget build(BuildContext context) {
    final item = product;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Details'),
        actions: [
          IconButton(
            onPressed: () async {
              try {
                final wishlistService = WishlistApiService();

                final response = await wishlistService.addToWishlistDemo(
                  productId: widget.productId,
                );

                if (!context.mounted) return;

                AppToast.show(
                  context,
                  message: response['message'] ?? 'Product added to wishlist',
                  type: ToastType.success,
                );
              } catch (error) {
                if (!context.mounted) return;

                AppToast.show(
                  context,
                  message: error.toString().replaceAll('Exception: ', ''),
                  type: ToastType.error,
                );
              }
            },
            icon: Icon(
              item?.isWishlist == true
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
            ),
          ),
        ],
      ),
      bottomNavigationBar: item == null
          ? null
          : SafeArea(
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: const BoxDecoration(
                  color: AppColors.lightSurface,
                  border: Border(top: BorderSide(color: AppColors.lightBorder)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: addToCartDemo,
                        child: const Text('Add to Cart'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: buyNowDemo,
                        child: const Text('Buy Now'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
          ? const Center(child: Text('Product not found'))
          : RefreshIndicator(
              onRefresh: fetchProductDetails,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _ProductImages(
                    product: item,
                    selectedIndex: selectedImageIndex,
                    onImageChanged: (index) {
                      setState(() {
                        selectedImageIndex = index;
                      });
                    },
                    onOpenGallery: openGallery,
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: item.stockStatus == 'in_stock'
                              ? AppColors.success.withValues(alpha: 0.12)
                              : AppColors.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          item.stockStatus.replaceAll('_', ' '),
                          style: TextStyle(
                            color: item.stockStatus == 'in_stock'
                                ? AppColors.success
                                : AppColors.warning,
                            fontWeight: FontWeight.w800,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.shortDescription,
                    style: const TextStyle(
                      color: AppColors.lightTextSecondary,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      Text(
                        '৳${item.discountPrice}',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontSize: 26,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '৳${item.price}',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          fontSize: 15,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        '-${item.discountPercentage}%',
                        style: const TextStyle(
                          color: AppColors.error,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        color: AppColors.warning,
                        size: 20,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.rating}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '(${item.totalReviews} reviews)',
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  ProductReviewsScreen(productId: item.id),
                            ),
                          );
                        },
                        child: const Text('View Reviews'),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _VariantSelector(
                    variants: item.variants,
                    selectedVariant: selectedVariant,
                    onSelected: (variant) {
                      setState(() {
                        selectedVariant = variant;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _QuantitySelector(
                    quantity: quantity,
                    maxQuantity: stock?.maxOrderQuantity ?? 5,
                    onChanged: (value) {
                      setState(() {
                        quantity = value;
                      });
                    },
                  ),
                  const SizedBox(height: 24),
                  _InfoCard(
                    title: 'Description',
                    child: Text(
                      item.description,
                      style: const TextStyle(
                        height: 1.5,
                        color: AppColors.lightTextSecondary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 18),
                  _InfoCard(
                    title: 'Specifications',
                    child: Column(
                      children: item.specifications.map((spec) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  spec.name,
                                  style: const TextStyle(
                                    color: AppColors.lightTextSecondary,
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  spec.value,
                                  textAlign: TextAlign.right,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 24),
                  RelatedProductsSection(productId: item.id),
                  const SizedBox(height: 100),
                ],
              ),
            ),
    );
  }
}

class _ProductImages extends StatelessWidget {
  final ProductDetailModel product;
  final int selectedIndex;
  final ValueChanged<int> onImageChanged;
  final void Function(List<String> images, int index) onOpenGallery;

  const _ProductImages({
    required this.product,
    required this.selectedIndex,
    required this.onImageChanged,
    required this.onOpenGallery,
  });

  @override
  Widget build(BuildContext context) {
    final imageUrls = product.images.map((image) => image.imageUrl).toList();

    if (imageUrls.isEmpty) {
      return Container(
        height: 320,
        decoration: BoxDecoration(
          color: AppColors.softMuted,
          borderRadius: BorderRadius.circular(24),
        ),
        child: const Icon(
          Icons.image_rounded,
          size: 60,
          color: AppColors.primary,
        ),
      );
    }

    return Column(
      children: [
        GestureDetector(
          onTap: () {
            onOpenGallery(imageUrls, selectedIndex);
          },
          child: Container(
            height: 320,
            width: double.infinity,
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: AppColors.softMuted,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Image.network(imageUrls[selectedIndex], fit: BoxFit.cover),
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 72,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: imageUrls.length,
            itemBuilder: (context, index) {
              final isSelected = index == selectedIndex;

              return GestureDetector(
                onTap: () {
                  onImageChanged(index);
                },
                child: Container(
                  width: 72,
                  height: 72,
                  margin: const EdgeInsets.only(right: 10),
                  clipBehavior: Clip.antiAlias,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.lightBorder,
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Image.network(imageUrls[index], fit: BoxFit.cover),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _VariantSelector extends StatelessWidget {
  final List<ProductVariantModel> variants;
  final ProductVariantModel? selectedVariant;
  final ValueChanged<ProductVariantModel> onSelected;

  const _VariantSelector({
    required this.variants,
    required this.selectedVariant,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) {
      return const SizedBox.shrink();
    }

    return _InfoCard(
      title: 'Variants',
      child: Wrap(
        spacing: 10,
        runSpacing: 10,
        children: variants.map((variant) {
          final isSelected = selectedVariant?.id == variant.id;

          return ChoiceChip(
            selected: isSelected,
            label: Text('${variant.type}: ${variant.name}'),
            onSelected: (_) {
              onSelected(variant);
            },
          );
        }).toList(),
      ),
    );
  }
}

class _QuantitySelector extends StatelessWidget {
  final int quantity;
  final int maxQuantity;
  final ValueChanged<int> onChanged;

  const _QuantitySelector({
    required this.quantity,
    required this.maxQuantity,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return _InfoCard(
      title: 'Quantity',
      child: Row(
        children: [
          IconButton.filledTonal(
            onPressed: quantity > 1
                ? () {
                    onChanged(quantity - 1);
                  }
                : null,
            icon: const Icon(Icons.remove_rounded),
          ),
          const SizedBox(width: 18),
          Text(
            '$quantity',
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(width: 18),
          IconButton.filledTonal(
            onPressed: quantity < maxQuantity
                ? () {
                    onChanged(quantity + 1);
                  }
                : null,
            icon: const Icon(Icons.add_rounded),
          ),
          const Spacer(),
          Text(
            'Max $maxQuantity',
            style: const TextStyle(color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
