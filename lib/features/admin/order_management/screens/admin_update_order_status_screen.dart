import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_order_model.dart';
import '../services/admin_order_api_service.dart';

class AdminUpdateOrderStatusScreen extends StatefulWidget {
  final AdminOrderListItemModel order;

  const AdminUpdateOrderStatusScreen({super.key, required this.order});

  @override
  State<AdminUpdateOrderStatusScreen> createState() =>
      _AdminUpdateOrderStatusScreenState();
}

class _AdminUpdateOrderStatusScreenState
    extends State<AdminUpdateOrderStatusScreen> {
  final AdminOrderApiService service = AdminOrderApiService();

  final noteController = TextEditingController(text: 'Order is now processing');
  final transactionController = TextEditingController(text: 'TXN-20260518-501');
  final paymentNoteController = TextEditingController(
    text: 'Payment received manually',
  );
  final courierController = TextEditingController(text: 'Pathao Courier');
  final trackingNumberController = TextEditingController(text: 'TRK123456789');
  final trackingUrlController = TextEditingController(
    text: 'https://courier.example.com/track/TRK123456789',
  );
  final deliveryDateController = TextEditingController(text: '2026-05-22');

  late String orderStatus;
  late String paymentStatus;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    orderStatus = widget.order.status.isEmpty ? 'pending' : widget.order.status;
    paymentStatus =
        widget.order.paymentStatus.isEmpty ? 'unpaid' : widget.order.paymentStatus;
  }

  @override
  void dispose() {
    noteController.dispose();
    transactionController.dispose();
    paymentNoteController.dispose();
    courierController.dispose();
    trackingNumberController.dispose();
    trackingUrlController.dispose();
    deliveryDateController.dispose();
    super.dispose();
  }

  Future<void> updateOrderStatus() async {
    setState(() => isLoading = true);

    try {
      final response = await service.updateStatusDemo(
        orderId: widget.order.id,
        status: orderStatus,
        note: noteController.text.trim(),
      );

      final updatedStatus = service.parseUpdatedStatus(response) ?? orderStatus;

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Order status updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, widget.order.copyWith(status: updatedStatus));
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> updatePaymentStatus() async {
    setState(() => isLoading = true);

    try {
      final response = await service.updatePaymentStatusDemo(
        orderId: widget.order.id,
        paymentStatus: paymentStatus,
        transactionId: transactionController.text.trim(),
        note: paymentNoteController.text.trim(),
      );

      final updatedPaymentStatus =
          service.parseUpdatedPaymentStatus(response) ?? paymentStatus;

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Payment status updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(
        context,
        widget.order.copyWith(paymentStatus: updatedPaymentStatus),
      );
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> updateTracking() async {
    setState(() => isLoading = true);

    try {
      final response = await service.updateTrackingDemo(
        orderId: widget.order.id,
        courierName: courierController.text.trim(),
        trackingNumber: trackingNumberController.text.trim(),
        trackingUrl: trackingUrlController.text.trim(),
        estimatedDeliveryDate: deliveryDateController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Tracking updated successfully',
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
      if (mounted) setState(() => isLoading = false);
    }
  }

  InputDecoration _decoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    final statuses = ['pending', 'processing', 'shipped', 'delivered', 'cancelled'];
    final paymentStatuses = ['unpaid', 'paid', 'failed', 'refunded'];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Order'),
      ),
      body: Stack(
        children: [
          ListView(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
            children: [
              _Header(order: widget.order),
              const SizedBox(height: 18),
              _SectionCard(
                title: 'Order Status',
                icon: Icons.local_shipping_outlined,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: statuses.contains(orderStatus) ? orderStatus : statuses.first,
                      decoration: _decoration('Status', Icons.flag_outlined),
                      items: statuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => orderStatus = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: noteController,
                      minLines: 2,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      decoration: _decoration('Status Note', Icons.notes_outlined),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : updateOrderStatus,
                        icon: const Icon(Icons.save_rounded),
                        label: const Text('Update Order Status'),
                      ),
                    ),
                  ],
                ),
              ),
              _SectionCard(
                title: 'Payment Status',
                icon: Icons.payments_outlined,
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: paymentStatuses.contains(paymentStatus)
                          ? paymentStatus
                          : paymentStatuses.first,
                      decoration: _decoration('Payment Status', Icons.credit_card_outlined),
                      items: paymentStatuses
                          .map(
                            (status) => DropdownMenuItem(
                              value: status,
                              child: Text(status.toUpperCase()),
                            ),
                          )
                          .toList(),
                      onChanged: (value) {
                        if (value != null) setState(() => paymentStatus = value);
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: transactionController,
                      decoration: _decoration('Transaction ID', Icons.confirmation_number_outlined),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: paymentNoteController,
                      minLines: 2,
                      maxLines: 4,
                      keyboardType: TextInputType.multiline,
                      textInputAction: TextInputAction.done,
                      decoration: _decoration('Payment Note', Icons.notes_outlined),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: FilledButton.icon(
                        onPressed: isLoading ? null : updatePaymentStatus,
                        icon: const Icon(Icons.payments_rounded),
                        label: const Text('Update Payment Status'),
                      ),
                    ),
                  ],
                ),
              ),
              _SectionCard(
                title: 'Tracking',
                icon: Icons.route_rounded,
                child: Column(
                  children: [
                    TextFormField(
                      controller: courierController,
                      decoration: _decoration('Courier Name', Icons.local_shipping_outlined),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: trackingNumberController,
                      decoration: _decoration('Tracking Number', Icons.numbers_rounded),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: trackingUrlController,
                      decoration: _decoration('Tracking URL', Icons.link_rounded),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: deliveryDateController,
                      decoration: _decoration('Estimated Delivery Date', Icons.event_outlined),
                    ),
                    const SizedBox(height: 14),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: isLoading ? null : updateTracking,
                        icon: const Icon(Icons.route_rounded),
                        label: const Text('Update Tracking'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          if (isLoading)
            Container(
              color: Colors.black.withValues(alpha: 0.06),
              child: const Center(child: CircularProgressIndicator()),
            ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final AdminOrderListItemModel order;

  const _Header({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            order.orderNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '${order.customer.name} • ৳${order.total}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
              ),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
