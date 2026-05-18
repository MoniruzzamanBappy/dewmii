import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/order_api_service.dart';

enum RequestType { returnRequest, refundRequest }

class ReturnRefundRequestScreen extends StatefulWidget {
  final int orderId;
  final String orderNumber;
  final RequestType requestType;

  const ReturnRefundRequestScreen({
    super.key,
    required this.orderId,
    required this.orderNumber,
    required this.requestType,
  });

  @override
  State<ReturnRefundRequestScreen> createState() =>
      _ReturnRefundRequestScreenState();
}

class _ReturnRefundRequestScreenState extends State<ReturnRefundRequestScreen> {
  final OrderApiService service = OrderApiService();

  late final TextEditingController reasonController;
  late final TextEditingController descriptionController;

  bool isLoading = false;

  bool get isReturn {
    return widget.requestType == RequestType.returnRequest;
  }

  Future<void> submitRequest() async {
    if (reasonController.text.trim().isEmpty ||
        descriptionController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please fill reason and description',
        type: ToastType.warning,
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      final response = isReturn
          ? await service.returnRequestDemo(
              orderId: widget.orderId,
              reason: reasonController.text.trim(),
              description: descriptionController.text.trim(),
            )
          : await service.refundRequestDemo(
              orderId: widget.orderId,
              reason: reasonController.text.trim(),
              description: descriptionController.text.trim(),
            );

      if (!mounted) return;

      AppToast.show(
        context,
        message:
            response['message'] ??
            '${isReturn ? 'Return' : 'Refund'} request submitted successfully',
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
  void initState() {
    super.initState();

    reasonController = TextEditingController(
      text: isReturn ? 'Product size is not correct' : 'Product damaged',
    );
    descriptionController = TextEditingController(
      text: isReturn
          ? 'I ordered M size but need L size'
          : 'The product was damaged during delivery',
    );
  }

  @override
  void dispose() {
    reasonController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title = isReturn ? 'Return Request' : 'Refund Request';

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            widget.orderNumber,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            isReturn
                ? 'Submit a return request for this order.'
                : 'Submit a refund request for this order.',
          ),
          const SizedBox(height: 20),
          TextField(
            controller: reasonController,
            decoration: const InputDecoration(labelText: 'Reason'),
          ),
          const SizedBox(height: 14),
          TextField(
            controller: descriptionController,
            minLines: 5,
            maxLines: 8,
            decoration: const InputDecoration(
              labelText: 'Description',
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: isLoading ? null : submitRequest,
            child: isLoading
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(strokeWidth: 2.4),
                  )
                : Text('Submit $title'),
          ),
        ],
      ),
    );
  }
}
