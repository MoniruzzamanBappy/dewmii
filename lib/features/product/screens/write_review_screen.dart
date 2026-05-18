import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../services/product_api_service.dart';

class WriteReviewScreen extends StatefulWidget {
  final int productId;

  const WriteReviewScreen({super.key, required this.productId});

  @override
  State<WriteReviewScreen> createState() => _WriteReviewScreenState();
}

class _WriteReviewScreenState extends State<WriteReviewScreen> {
  final ProductApiService service = ProductApiService();
  final commentController = TextEditingController();

  int rating = 5;
  bool isLoading = false;

  Future<void> submitReview() async {
    if (commentController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please write your review',
        type: ToastType.warning,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await service.addReviewDemo(
        productId: widget.productId,
        rating: rating,
        comment: commentController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Review submitted successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, true);
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
  void dispose() {
    commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write Review')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Your Rating',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          Row(
            children: List.generate(5, (index) {
              final star = index + 1;

              return IconButton(
                onPressed: () {
                  setState(() {
                    rating = star;
                  });
                },
                icon: Icon(
                  star <= rating
                      ? Icons.star_rounded
                      : Icons.star_border_rounded,
                  color: AppColors.warning,
                  size: 34,
                ),
              );
            }),
          ),
          const SizedBox(height: 24),
          const Text(
            'Review',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: commentController,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              hintText: 'Write your experience with this product...',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 28),
          ElevatedButton(
            onPressed: isLoading ? null : submitReview,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Submit Review'),
          ),
        ],
      ),
    );
  }
}
