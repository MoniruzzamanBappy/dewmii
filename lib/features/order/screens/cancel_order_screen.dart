import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/navigation/common_app_header.dart';
import '../services/order_api_service.dart';

class CancelOrderScreen extends StatefulWidget {
  final int orderId;
  final String orderNumber;

  const CancelOrderScreen({super.key, required this.orderId, required this.orderNumber});

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final OrderApiService service = OrderApiService();
  final reasonController = TextEditingController(text: 'I ordered by mistake');
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  Future<void> cancelOrder() async {
    if (!(formKey.currentState?.validate() ?? false)) return;
    setState(() => isLoading = true);
    try {
      final response = await service.cancelOrderDemo(orderId: widget.orderId, reason: reasonController.text.trim());
      if (!mounted) return;
      AppToast.show(context, message: response['message']?.toString() ?? 'Order cancelled successfully.', type: ToastType.success);
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: const CommonAppHeader(title: 'Cancel Order', showBackButton: true),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _WarningHero(orderNumber: widget.orderNumber),
            const SizedBox(height: 22),
            Text('Cancellation reason', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
            const SizedBox(height: 10),
            TextFormField(
              controller: reasonController,
              minLines: 4,
              maxLines: 7,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.done,
              validator: (value) => (value == null || value.trim().length < 5) ? 'Please write a valid reason.' : null,
              decoration: InputDecoration(
                hintText: 'Tell us why you want to cancel this order',
                alignLabelWithHint: true,
                filled: true,
                prefixIcon: const Padding(
                  padding: EdgeInsets.only(bottom: 72),
                  child: Icon(Icons.edit_note_rounded),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(22), borderSide: BorderSide.none),
              ),
            ),
            const SizedBox(height: 18),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.warning.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_rounded, color: AppColors.warning),
                  const SizedBox(width: 10),
                  Expanded(child: Text('Cancellation is only available before the order is shipped.', style: theme.textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600))),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 18),
          child: ElevatedButton.icon(
            onPressed: isLoading ? null : cancelOrder,
            icon: isLoading ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.cancel_rounded),
            label: Text(isLoading ? 'Cancelling...' : 'Cancel Order'),
            style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(54)),
          ),
        ),
      ),
    );
  }
}

class _WarningHero extends StatelessWidget {
  final String orderNumber;

  const _WarningHero({required this.orderNumber});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFFFB86B), Color(0xFFEF4444)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.error.withValues(alpha: 0.22), blurRadius: 26, offset: const Offset(0, 16))],
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 42),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Cancel this order?', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(orderNumber.isEmpty ? 'Order #pending' : orderNumber, style: TextStyle(color: Colors.white.withValues(alpha: 0.86), fontWeight: FontWeight.w700)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
