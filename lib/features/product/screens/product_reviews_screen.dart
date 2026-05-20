import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/product_review_model.dart';
import '../services/product_api_service.dart';
import '../widgets/product_rating_summary.dart';
import '../widgets/product_review_card.dart';
import 'write_review_screen.dart';

class ProductReviewsScreen extends StatefulWidget {
  final int productId;

  const ProductReviewsScreen({super.key, required this.productId});

  @override
  State<ProductReviewsScreen> createState() => _ProductReviewsScreenState();
}

class _ProductReviewsScreenState extends State<ProductReviewsScreen> {
  final ProductApiService service = ProductApiService();

  bool isLoading = true;
  ProductReviewsResponseModel? response;

  Future<void> fetchReviews() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getProductReviews(widget.productId);
      if (!mounted) return;
      setState(() => response = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> openWriteReview() async {
    final result = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => WriteReviewScreen(productId: widget.productId)),
    );
    if (result == true) fetchReviews();
  }

  @override
  void initState() {
    super.initState();
    fetchReviews();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final reviews = response?.reviews ?? [];

    return Scaffold(
      appBar: AppBar(title: const Text('Reviews'), centerTitle: true),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openWriteReview,
        icon: const Icon(Icons.rate_review_rounded),
        label: const Text('Write Review'),
      ),
      body: RefreshIndicator(
        onRefresh: fetchReviews,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 250),
          child: isLoading
              ? const _ReviewsSkeleton(key: ValueKey('loading'))
              : reviews.isEmpty
                  ? _EmptyReviews(key: const ValueKey('empty'), onWrite: openWriteReview)
                  : ListView(
                      key: const ValueKey('content'),
                      padding: const EdgeInsets.fromLTRB(18, 14, 18, 100),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: AppColors.primaryGradient,
                            borderRadius: BorderRadius.circular(28),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.reviews_rounded, color: Colors.white, size: 34),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Real customer feedback', style: theme.textTheme.titleMedium?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                                    const SizedBox(height: 4),
                                    Text('${reviews.length} reviews available', style: const TextStyle(color: Colors.white70)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 18),
                        ProductRatingSummary(summary: response!.summary),
                        const SizedBox(height: 18),
                        ...List.generate(reviews.length, (index) {
                          return TweenAnimationBuilder<double>(
                            tween: Tween(begin: 0, end: 1),
                            duration: Duration(milliseconds: 240 + index * 45),
                            curve: Curves.easeOutCubic,
                            builder: (context, value, child) => Opacity(
                              opacity: value,
                              child: Transform.translate(offset: Offset(0, 16 * (1 - value)), child: child),
                            ),
                            child: ProductReviewCard(review: reviews[index]),
                          );
                        }),
                      ],
                    ),
        ),
      ),
    );
  }
}

class _ReviewsSkeleton extends StatelessWidget {
  const _ReviewsSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.surfaceContainerHighest;
    return ListView.builder(
      padding: const EdgeInsets.all(18),
      itemCount: 5,
      itemBuilder: (_, index) => Container(
        height: index == 0 ? 160 : 120,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(24)),
      ),
    );
  }
}

class _EmptyReviews extends StatelessWidget {
  final VoidCallback onWrite;

  const _EmptyReviews({super.key, required this.onWrite});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 80),
        Icon(Icons.rate_review_outlined, size: 82, color: theme.colorScheme.primary.withOpacity(.35)),
        const SizedBox(height: 18),
        Text('No reviews yet', textAlign: TextAlign.center, style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('Be the first customer to share your product experience.', textAlign: TextAlign.center, style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant)),
        const SizedBox(height: 22),
        FilledButton.icon(onPressed: onWrite, icon: const Icon(Icons.edit_rounded), label: const Text('Write first review')),
      ],
    );
  }
}
