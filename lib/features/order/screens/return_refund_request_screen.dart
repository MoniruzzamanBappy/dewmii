import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/navigation/common_app_header.dart';
import '../services/order_api_service.dart';

class ReturnRefundRequestScreen extends StatefulWidget {
  final int orderId;
  final String orderNumber;
  final bool isReturn;

  const ReturnRefundRequestScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.isReturn,
  });

  @override
  State<ReturnRefundRequestScreen> createState() => _ReturnRefundRequestScreenState();
}

class _ReturnRefundRequestScreenState extends State<ReturnRefundRequestScreen> {
  final OrderApiService service = OrderApiService();
  final formKey = GlobalKey<FormState>();
  final reasonController = TextEditingController();
  final descriptionController = TextEditingController();
  bool isLoading = false;

  Future<void> submitRequest() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => isLoading = true);
    try {
      final response = widget.isReturn
          ? await service.returnRequestDemo(orderId: widget.orderId, reason: reasonController.text.trim(), description: descriptionController.text.trim())
          : await service.refundRequestDemo(orderId: widget.orderId, reason: reasonController.text.trim(), description: descriptionController.text.trim());
      if (!mounted) return;
      AppToast.show(context, message: response['message']?.toString() ?? 'Request submitted successfully.', type: ToastType.success);
      Navigator.pop(context, true);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void dispose() {
    reasonController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = widget.isReturn ? 'Return Request' : 'Refund Request';
    return Scaffold(
      appBar: CommonAppHeader(title: title, showBackButton: true),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _RequestHero(title: title, orderNumber: widget.orderNumber, icon: widget.isReturn ? Icons.assignment_return_rounded : Icons.payments_rounded),
            const SizedBox(height: 22),
            TextFormField(
              controller: reasonController,
              textInputAction: TextInputAction.next,
              validator: (value) => (value == null || value.trim().length < 3) ? 'Please enter a reason.' : null,
              decoration: InputDecoration(
                labelText: 'Reason',
                hintText: widget.isReturn ? 'Wrong size, damaged item, etc.' : 'Payment issue, duplicate payment, etc.',
                prefixIcon: const Icon(Icons.flag_rounded),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: descriptionController,
              minLines: 5,
              maxLines: 8,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              validator: (value) => (value == null || value.trim().length < 10) ? 'Please add a short description.' : null,
              decoration: InputDecoration(
                labelText: 'Description',
                alignLabelWithHint: true,
                hintText: 'Add details so support can process your request faster.',
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 86),
                  child: Icon(Icons.notes_rounded),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
            const SizedBox(height: 16),
            _InfoBox(isReturn: widget.isReturn),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : submitRequest,
            icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded),
            label: Text(isLoading ? 'Submitting...' : 'Submit $title'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
          ),
        ),
      ),
    );
  }
}

class _RequestHero extends StatelessWidget {
  final String title;
  final String orderNumber;
  final IconData icon;

  const _RequestHero({required this.title, required this.orderNumber, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.sageGradient,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.35)),
      ),
      child: Row(
        children: [
          Container(width: 58, height: 58, decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.12), borderRadius: BorderRadius.circular(20)), child: Icon(icon, color: AppColors.primary, size: 30)),
          const SizedBox(width: 16),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 5), Text(orderNumber, style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w700))])),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final bool isReturn;

  const _InfoBox({required this.isReturn});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.info.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.info.withValues(alpha: 0.18))),
      child: Row(children: [const Icon(Icons.info_rounded, color: AppColors.info), const SizedBox(width: 10), Expanded(child: Text(isReturn ? 'Keep the product packaging ready for return verification.' : 'Refunds may take a few business days after approval.', style: Theme.of(context).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600)))]),
    );
  }
}
