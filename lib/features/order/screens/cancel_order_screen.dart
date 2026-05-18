import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/order_api_service.dart';

class CancelOrderScreen extends StatefulWidget {
  final int orderId;
  final String orderNumber;

  const CancelOrderScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
  });

  @override
  State<CancelOrderScreen> createState() => _CancelOrderScreenState();
}

class _CancelOrderScreenState extends State<CancelOrderScreen> {
  final OrderApiService service = OrderApiService();
  final reasonController = TextEditingController(text: 'I ordered by mistake');

  bool isLoading = false;

  Future<void> cancelOrder() async {
    if (reasonController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please enter cancellation reason',
        type: ToastType.warning,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = await service.cancelOrderDemo(
        orderId: widget.orderId,
        reason: reasonController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Order cancelled successfully',
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
    reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Cancel Order')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.orderNumber,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text('Please tell us why you want to cancel this order.'),
          const SizedBox(height: 20),
          TextField(
            controller: reasonController,
            minLines: 4,
            maxLines: 7,
            decoration: const InputDecoration(
              labelText: 'Cancel Reason',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : cancelOrder,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : const Text('Cancel Order'),
          ),
        ],
      ),
    );
  }
}
