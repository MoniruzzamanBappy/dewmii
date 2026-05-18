import 'package:dewmii/features/product/screens/write_review_screen.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/product_review_model.dart';
import '../services/product_api_service.dart';
import '../widgets/product_rating_summary.dart';
import '../widgets/product_review_card.dart';

class ProductReviewsScreen extends StatefulWidget {
  final int productId;

  const ProductReviewsScreen({super.key, required this.productId});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final ProductApiService service = ProductApiService();

  bool isLoading = true;
  ProductReviewsResponseModel? reviewsResponse;

  Future<void> fetchReviews() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getProductReviews(widget.productId);

      if (!mounted) return;

      setState(() {
        reviewsResponse = result;
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

  Future<void> openWriteReview() async {
    final shouldRefresh = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => WriteReviewScreen(productId: widget.productId),
      ),
    );

    if (shouldRefresh == true) {
      fetchReviews();
    }
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    final response = reviewsResponse;

    return Scaffold(
      appBar: AppBar(title: const Text('Product Reviews')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openWriteReview,
        icon: const Icon(Icons.rate_review_rounded),
        label: const Text('Write Review'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : response == null
          ? const Center(child: Text('No reviews found'))
          : RefreshIndicator(
              onRefresh: fetchReviews,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  ProductRatingSummary(summary: response.summary),
                  const SizedBox(height: 20),
                  ...response.reviews.map((review) {
                    return ProductReviewCard(review: review);
                  }),
                  const SizedBox(height: 80),
                ],
              ),
            ),
    );
  }
}
