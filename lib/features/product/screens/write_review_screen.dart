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
  final _formKey = GlobalKey<FormState>();
  final _commentController = TextEditingController();
  final ProductApiService service = ProductApiService();

  int rating = 5;
  bool isSubmitting = false;

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> submitReview() async {
    if (!_formKey.currentState!.validate()) return;
    FocusScope.of(context).unfocus();
    setState(() => isSubmitting = true);
    try {
      final result = await service.addReviewDemo(productId: widget.productId, rating: rating, comment: _commentController.text.trim());
      if (!mounted) return;
      AppToast.show(context, message: result['message']?.toString() ?? 'Review submitted', type: ToastType.success);
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Write Review'), centerTitle: true),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(18, 10, 18, 18),
        child: FilledButton.icon(
          onPressed: isSubmitting ? null : submitReview,
          icon: isSubmitting
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
              : const Icon(Icons.send_rounded),
          label: Text(isSubmitting ? 'Submitting...' : 'Submit Review'),
          style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(54), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18))),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(28)),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 34),
                    const SizedBox(height: 14),
                    Text('How was the product?', style: theme.textTheme.headlineSmall?.copyWith(color: Colors.white, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 6),
                    const Text('Your feedback helps other shoppers choose confidently.', style: TextStyle(color: Colors.white70, height: 1.35)),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text('Your rating', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(color: scheme.surface, borderRadius: BorderRadius.circular(22), border: Border.all(color: scheme.outlineVariant.withValues(alpha: .55))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final selected = index < rating;
                    return IconButton(
                      tooltip: '${index + 1} star',
                      onPressed: () => setState(() => rating = index + 1),
                      icon: AnimatedScale(
                        duration: const Duration(milliseconds: 180),
                        scale: selected ? 1.18 : 1,
                        child: Icon(selected ? Icons.star_rounded : Icons.star_border_rounded, size: 34, color: AppColors.warning),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 22),
              Text('Review details', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              TextFormField(
                controller: _commentController,
                minLines: 5,
                maxLines: 7,
                keyboardType: TextInputType.multiline,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: 'Tell us about quality, fit, delivery, packaging...',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(bottom: 92),
                    child: Icon(Icons.notes_rounded),
                  ),
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: BorderSide.none),
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  if (text.length < 8) return 'Please write at least 8 characters.';
                  return null;
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
