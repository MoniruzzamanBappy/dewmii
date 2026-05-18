import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/order_details_model.dart';
import '../services/order_api_service.dart';
import '../widgets/order_item_card.dart';
import 'cancel_order_screen.dart';
import 'order_tracking_screen.dart';
import 'return_refund_request_screen.dart';

class OrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final OrderApiService service = OrderApiService();

  bool isLoading = true;
  OrderDetailsModel? order;

  Future<void> fetchDetails() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getOrderDetails(widget.orderId);

      if (!mounted) return;

      setState(() {
        order = result;
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

  Future<void> downloadInvoice() async {
    try {
      final invoice = await service.getInvoiceDemo(orderId: widget.orderId);

      if (!mounted) return;

      AppToast.show(
        context,
        message: invoice == null
            ? 'Invoice not found'
            : 'Invoice generated: ${invoice.invoiceNumber}',
        type: invoice == null ? ToastType.warning : ToastType.success,
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

  Future<void> openCancel(OrderDetailsModel order) async {
    final cancelled = await Navigator.push<bool>(
      context,
      MaterialPageRoute(
        builder: (_) => CancelOrderScreen(
          orderId: order.id,
          orderNumber: order.orderNumber,
        ),
      ),
    );

    if (cancelled == true) {
      setState(() {
        this.order = order.copyWith(status: 'cancelled');
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    final item = order;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
          ? const Center(child: Text('Order not found'))
          : RefreshIndicator(
              onRefresh: fetchDetails,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  _OrderHeader(order: item),
                  const SizedBox(height: 18),
                  _InfoCard(
                    title: 'Delivery Address',
                    child: Text(
                      '${item.address.name}\n${item.address.phone}\n${item.address.fullAddress}',
                      style: const TextStyle(height: 1.5),
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Items',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 12),
                  ...item.items.map((orderItem) {
                    return OrderItemCard(item: orderItem);
                  }),
                  const SizedBox(height: 18),
                  _InfoCard(
                    title: 'Payment Summary',
                    child: Column(
                      children: [
                        _SummaryRow(
                          label: 'Subtotal',
                          value: '৳${item.subtotal}',
                        ),
                        _SummaryRow(
                          label: 'Discount',
                          value: '-৳${item.discount}',
                          color: AppColors.success,
                        ),
                        _SummaryRow(
                          label: 'Shipping',
                          value: '৳${item.shippingCharge}',
                        ),
                        _SummaryRow(label: 'Tax', value: '৳${item.tax}'),
                        const Divider(height: 26),
                        _SummaryRow(
                          label: 'Total',
                          value: '৳${item.total}',
                          isTotal: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => OrderTrackingScreen(orderId: item.id),
                        ),
                      );
                    },
                    icon: const Icon(Icons.local_shipping_rounded),
                    label: const Text('Track Order'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: downloadInvoice,
                    icon: const Icon(Icons.picture_as_pdf_rounded),
                    label: const Text('Download Invoice Demo'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: item.status == 'pending'
                        ? () {
                            openCancel(item);
                          }
                        : null,
                    icon: const Icon(Icons.cancel_rounded),
                    label: const Text('Cancel Order'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReturnRefundRequestScreen(
                            orderId: item.id,
                            orderNumber: item.orderNumber,
                            requestType: RequestType.returnRequest,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.assignment_return_rounded),
                    label: const Text('Return Request'),
                  ),
                  const SizedBox(height: 10),
                  OutlinedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => ReturnRefundRequestScreen(
                            orderId: item.id,
                            orderNumber: item.orderNumber,
                            requestType: RequestType.refundRequest,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(Icons.payments_rounded),
                    label: const Text('Refund Request'),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }
}

class _OrderHeader extends StatelessWidget {
  final OrderDetailsModel order;

  const _OrderHeader({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.orderNumber,
            style: const TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w900,
              color: AppColors.lightTextPrimary,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Status: ${order.status.toUpperCase()}',
            style: const TextStyle(
              color: AppColors.lightTextSecondary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Payment: ${order.paymentStatus} • ${order.paymentMethod.toUpperCase()}',
            style: const TextStyle(color: AppColors.lightTextSecondary),
          ),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final Widget child;

  const _InfoCard({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;
  final bool isTotal;

  const _SummaryRow({
    required this.label,
    required this.value,
    this.color,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 11),
      child: Row(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isTotal
                  ? AppColors.lightTextPrimary
                  : AppColors.lightTextSecondary,
              fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              color: color ?? AppColors.lightTextPrimary,
              fontWeight: FontWeight.w900,
              fontSize: isTotal ? 20 : 14,
            ),
          ),
        ],
      ),
    );
  }
}
