import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_product_detail_model.dart';
import '../models/admin_product_image_model.dart';
import '../models/admin_product_model.dart';
import '../services/admin_product_api_service.dart';
import '../widgets/admin_product_form.dart';
import '../widgets/admin_product_image_card.dart';

class AdminEditProductScreen extends StatefulWidget {
  final int productId;
  final AdminProductModel fallbackProduct;

  const AdminEditProductScreen({
    super.key,
    required this.productId,
    required this.fallbackProduct,
  });

  @override
  State<AdminEditProductScreen> createState() => _AdminEditProductScreenState();
}

class _AdminEditProductScreenState extends State<AdminEditProductScreen> {
  final AdminProductApiService service = AdminProductApiService();

  bool isLoading = true;
  bool isSaving = false;
  bool isImageLoading = false;

  AdminProductDetailModel? productDetails;
  List<AdminProductImageModel> images = [];

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    setState(() => isLoading = true);

    try {
      final details = await service.getProductDetails(widget.productId);

      if (!mounted) return;

      setState(() {
        productDetails = details;
        images = details?.images ?? [];
      });
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

  Future<void> updateProduct(Map<String, dynamic> body) async {
    setState(() => isSaving = true);

    try {
      final response = await service.updateProductDemo(
        productId: widget.productId,
        body: body,
      );

      final updatedProduct =
          service.parseProduct(response) ??
          widget.fallbackProduct.copyWith(
            name: body['name']?.toString(),
            sku: body['sku']?.toString(),
            price: body['price'] is num ? body['price'] as num : null,
            discountPrice:
                body['discount_price'] is num ? body['discount_price'] as num : null,
            stock: body['stock'] is int ? body['stock'] as int : null,
            status: body['status']?.toString(),
            isFeatured: body['is_featured'] == true,
          );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Product updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, updatedProduct);
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  Future<void> uploadImages() async {
    setState(() => isImageLoading = true);

    try {
      final uploadedImages = await service.uploadImagesDemo(
        productId: widget.productId,
      );

      if (!mounted) return;

      setState(() {
        images = uploadedImages.isEmpty ? images : uploadedImages;
      });

      AppToast.show(
        context,
        message: 'Product images uploaded successfully',
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
      if (mounted) setState(() => isImageLoading = false);
    }
  }

  Future<void> deleteImage(AdminProductImageModel image) async {
    final confirmed = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.delete_outline_rounded, size: 48, color: AppColors.error),
              const SizedBox(height: 10),
              const Text(
                'Delete this image?',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 8),
              const Text(
                'This will remove the image from the product gallery.',
                textAlign: TextAlign.center,
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

    try {
      final response = await service.deleteImageDemo(
        productId: widget.productId,
        imageId: image.id,
      );
      final deletedId = service.parseDeletedImageId(response) ?? image.id;

      if (!mounted) return;

      setState(() {
        images.removeWhere((item) => item.id == deletedId);
      });

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Image deleted',
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

  @override
  Widget build(BuildContext context) {
    final details = productDetails;

    return Scaffold(
      appBar: AppBar(title: const Text('Edit Product')),
      body: isLoading
          ? const _EditProductSkeleton()
          : RefreshIndicator(
              onRefresh: fetchDetails,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: [
                  _EditHero(product: widget.fallbackProduct),
                  const SizedBox(height: 18),
                  _ImagesSection(
                    images: images,
                    isLoading: isImageLoading,
                    onUpload: uploadImages,
                    onDelete: deleteImage,
                  ),
                  const SizedBox(height: 18),
                  AdminProductForm(
                    initialName: details?.name ?? widget.fallbackProduct.name,
                    initialSku: details?.sku ?? widget.fallbackProduct.sku,
                    initialShortDescription: details?.shortDescription,
                    initialDescription: details?.description,
                    initialPrice: details?.price ?? widget.fallbackProduct.price,
                    initialDiscountPrice:
                        details?.discountPrice ?? widget.fallbackProduct.discountPrice,
                    initialStock: details?.stock ?? widget.fallbackProduct.stock,
                    initialFeatured:
                        details?.isFeatured ?? widget.fallbackProduct.isFeatured,
                    initialStatus: details?.status ?? widget.fallbackProduct.status,
                    isLoading: isSaving,
                    submitLabel: 'Update Product',
                    onSubmit: updateProduct,
                  ),
                ],
              ),
            ),
    );
  }
}

class _EditHero extends StatelessWidget {
  final AdminProductModel product;

  const _EditHero({required this.product});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Hero(
            tag: 'admin-product-${product.id}',
            child: CircleAvatar(
              radius: 28,
              backgroundColor: Colors.white24,
              backgroundImage: product.thumbnail.isEmpty
                  ? null
                  : NetworkImage(product.thumbnail),
              child: product.thumbnail.isEmpty
                  ? const Icon(Icons.inventory_2_rounded, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              product.name,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ImagesSection extends StatelessWidget {
  final List<AdminProductImageModel> images;
  final bool isLoading;
  final VoidCallback onUpload;
  final ValueChanged<AdminProductImageModel> onDelete;

  const _ImagesSection({
    required this.images,
    required this.isLoading,
    required this.onUpload,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Product Images',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                ),
              ),
              FilledButton.icon(
                onPressed: isLoading ? null : onUpload,
                icon: isLoading
                    ? const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.upload_rounded),
                label: const Text('Upload'),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 132,
            child: images.isEmpty
                ? const Center(child: Text('No images uploaded yet'))
                : ListView(
                    scrollDirection: Axis.horizontal,
                    children: images
                        .map(
                          (image) => AdminProductImageCard(
                            image: image,
                            onDelete: () => onDelete(image),
                          ),
                        )
                        .toList(),
                  ),
          ),
        ],
      ),
    );
  }
}

class _EditProductSkeleton extends StatelessWidget {
  const _EditProductSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        5,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: index == 0 ? 120 : 88,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(24),
          ),
        ),
      ),
    );
  }
}
