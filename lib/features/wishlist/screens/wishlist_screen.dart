import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../product/screens/product_details_screen.dart';
import '../models/wishlist_item_model.dart';
import '../services/wishlist_api_service.dart';
import '../widgets/wishlist_item_card.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  final WishlistApiService service = WishlistApiService();

  bool isLoading = true;
  bool isActionLoading = false;

  List<WishlistItemModel> items = [];
  int wishlistCount = 0;

  Future<void> fetchWishlist() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getWishlist();

      if (!mounted) return;

      setState(() {
        items = result;
        wishlistCount = result.length;
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

  Future<void> removeItem(WishlistItemModel item) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.removeFromWishlistDemo(
        productId: item.productId,
      );

      final removedProductId =
          service.parseRemovedProductId(response) ?? item.productId;

      if (!mounted) return;

      setState(() {
        items = items.where((wishlistItem) {
          return wishlistItem.productId != removedProductId;
        }).toList();

        wishlistCount = service.parseWishlistCount(response) ?? items.length;
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Product removed from wishlist',
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
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> moveToCart(WishlistItemModel item) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.moveToCartDemo(productId: item.productId);

      if (!mounted) return;

      setState(() {
        items = items.where((wishlistItem) {
          return wishlistItem.productId != item.productId;
        }).toList();

        wishlistCount = service.parseWishlistCount(response) ?? items.length;
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Product moved to cart successfully',
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
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> addDemoProduct() async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.addToWishlistDemo(productId: 101);

      final addedItem = service.parseAddedWishlistItem(response);

      if (!mounted) return;

      setState(() {
        if (addedItem != null) {
          final alreadyExists = items.any((item) {
            return item.productId == addedItem.productId;
          });

          if (!alreadyExists) {
            items = [addedItem, ...items];
          }
        }

        wishlistCount = service.parseWishlistCount(response) ?? items.length;
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Product added to wishlist',
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
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  void openProductDetails(WishlistItemModel item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProductDetailsScreen(productId: item.productId),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchWishlist();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Wishlist ($wishlistCount)'),
        actions: [
          IconButton(
            onPressed: isActionLoading ? null : addDemoProduct,
            icon: const Icon(Icons.favorite_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchWishlist,
              child: items.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.favorite_border_rounded,
                          size: 94,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Your wishlist is empty',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Tap the heart icon on products to save them here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.lightTextSecondary),
                        ),
                        const SizedBox(height: 26),
                        ElevatedButton.icon(
                          onPressed: isActionLoading ? null : addDemoProduct,
                          icon: const Icon(Icons.favorite_rounded),
                          label: const Text('Add Demo Product'),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (isActionLoading) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: 14),
                        ],
                        const Text(
                          'Saved Favorite Products',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...items.map((item) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: WishlistItemCard(
                              item: item,
                              onTap: () {
                                openProductDetails(item);
                              },
                              onRemove: isActionLoading
                                  ? () {}
                                  : () {
                                      removeItem(item);
                                    },
                              onMoveToCart: isActionLoading
                                  ? () {}
                                  : () {
                                      moveToCart(item);
                                    },
                            ),
                          );
                        }),
                        const SizedBox(height: 40),
                      ],
                    ),
            ),
    );
  }
}
