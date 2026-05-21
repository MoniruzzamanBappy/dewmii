import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/navigation/common_app_header.dart';
import '../models/invoice_model.dart';
import '../models/order_details_model.dart';
import '../screens/cancel_order_screen.dart';
import '../screens/order_tracking_screen.dart';
import '../screens/return_refund_request_screen.dart';
import '../services/order_api_service.dart';
import '../widgets/order_item_card.dart';

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
    setState(() => isLoading = true);
    try {
      final result = await service.getOrderDetails(widget.orderId);
      if (!mounted) return;
      setState(() => order = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> downloadInvoice() async {
    try {
      final InvoiceModel? invoice = await service.getInvoiceDemo(orderId: widget.orderId);
      if (!mounted) return;
      AppToast.show(context, message: invoice?.invoiceNumber.isNotEmpty == true ? 'Invoice ${invoice!.invoiceNumber} is ready.' : 'Invoice is ready.', type: ToastType.success);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    }
  }

  Future<void> openCancel() async {
    final current = order;
    if (current == null) return;
    final cancelled = await Navigator.push<bool>(context, _route(CancelOrderScreen(orderId: current.id, orderNumber: current.orderNumber)));
    if (cancelled == true && mounted) setState(() => order = current.copyWith(status: 'cancelled'));
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CommonAppHeader(
        title: 'Order Details',
        showBackButton: true,
        actions: [IconButton(onPressed: downloadInvoice, icon: const Icon(Icons.download_rounded), tooltip: 'Invoice')],
      ),
      body: isLoading ? _skeleton(context) : _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final current = order;
    if (current == null) {
      return Center(child: Text('Order details not found.', style: Theme.of(context).textTheme.titleMedium));
    }

    final canCancel = ['pending', 'confirmed', 'processing'].contains(current.status.toLowerCase());
    final canReturn = ['delivered', 'completed'].contains(current.status.toLowerCase());

    return RefreshIndicator(
      onRefresh: fetchDetails,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          _DetailsHero(order: current),
          const SizedBox(height: 18),
          _ActionGrid(
            onTrack: () => Navigator.push(context, _route(OrderTrackingScreen(orderId: current.id))),
            onInvoice: downloadInvoice,
            onCancel: canCancel ? openCancel : null,
            onReturn: canReturn ? () => Navigator.push(context, _route(ReturnRefundRequestScreen(orderId: current.id, orderNumber: current.orderNumber, isReturn: true))) : null,
          ),
          const SizedBox(height: 22),
          _SectionTitle(title: 'Items (${current.items.length})'),
          const SizedBox(height: 12),
          ...current.items.map((item) => OrderItemCard(item: item)),
          const SizedBox(height: 10),
          _AddressCard(address: current.address),
          const SizedBox(height: 14),
          _PaymentSummary(order: current),
          if (current.note.trim().isNotEmpty) ...[
            const SizedBox(height: 14),
            _NoteCard(note: current.note),
          ],
        ],
      ),
    );
  }

  Widget _skeleton(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      itemBuilder: (_, index) => Container(
        height: index == 0 ? 180 : 96,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(26)),
      ),
    );
  }

  Route<T> _route<T>(Widget page) => PageRouteBuilder<T>(
        pageBuilder: (_, _, _) => page,
        transitionDuration: const Duration(milliseconds: 250),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(opacity: animation, child: SlideTransition(position: Tween<Offset>(begin: const Offset(0.06, 0.02), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)), child: child)),
      );
}

class _DetailsHero extends StatelessWidget {
  final OrderDetailsModel order;

  const _DetailsHero({required this.order});

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(order.status, Theme.of(context).colorScheme.primary);
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.24), blurRadius: 28, offset: const Offset(0, 16))]),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(order.orderNumber.isEmpty ? 'Order #${order.id}' : order.orderNumber, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))), Container(padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(999)), child: Text(_label(order.status), style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.w900)))]),
        const SizedBox(height: 8),
        Text(_date(order.createdAt), style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontWeight: FontWeight.w600)),
        const SizedBox(height: 18),
        Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(22)), child: Row(children: [Expanded(child: _HeroMetric(label: 'Total', value: _money(order.total))), Expanded(child: _HeroMetric(label: 'Payment', value: _label(order.paymentMethod))), Expanded(child: _HeroMetric(label: 'Status', value: _label(order.paymentStatus), valueColor: statusColor))])),
      ]),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;
  final Color? valueColor;
  const _HeroMetric({required this.label, required this.value, this.valueColor});
  @override
  Widget build(BuildContext context) => Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontSize: 11)), const SizedBox(height: 4), Text(value, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: valueColor ?? Colors.white, fontWeight: FontWeight.w900))]);
}

class _ActionGrid extends StatelessWidget {
  final VoidCallback onTrack;
  final VoidCallback onInvoice;
  final VoidCallback? onCancel;
  final VoidCallback? onReturn;
  const _ActionGrid({required this.onTrack, required this.onInvoice, this.onCancel, this.onReturn});
  @override
  Widget build(BuildContext context) => Row(children: [Expanded(child: _ActionButton(icon: Icons.local_shipping_rounded, label: 'Track', onTap: onTrack)), const SizedBox(width: 10), Expanded(child: _ActionButton(icon: Icons.download_rounded, label: 'Invoice', onTap: onInvoice)), const SizedBox(width: 10), Expanded(child: _ActionButton(icon: onCancel != null ? Icons.cancel_rounded : Icons.assignment_return_rounded, label: onCancel != null ? 'Cancel' : 'Return', onTap: onCancel ?? onReturn))]);
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback? onTap;

  const _ActionButton({required this.icon, required this.label, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).cardColor,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Opacity(
          opacity: onTap == null ? 0.45 : 1,
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: Theme.of(context).dividerColor.withValues(alpha: 0.22),
              ),
            ),
            child: Column(
              children: [
                Icon(icon, color: Theme.of(context).colorScheme.primary),
                const SizedBox(height: 6),
                Text(label, style: const TextStyle(fontWeight: FontWeight.w800)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget { final String title; const _SectionTitle({required this.title}); @override Widget build(BuildContext context) => Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)); }

class _AddressCard extends StatelessWidget {
  final OrderAddressModel address;
  const _AddressCard({required this.address});
  @override
  Widget build(BuildContext context) => _InfoCard(icon: Icons.location_on_rounded, title: 'Shipping Address', children: [Text(address.name, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(address.phone), const SizedBox(height: 4), Text(address.fullAddress)]);
}

class _PaymentSummary extends StatelessWidget {
  final OrderDetailsModel order;
  const _PaymentSummary({required this.order});
  @override
  Widget build(BuildContext context) => _InfoCard(icon: Icons.payments_rounded, title: 'Payment Summary', children: [_row('Subtotal', order.subtotal), _row('Discount', -order.discount), _row('Shipping', order.shippingCharge), _row('Tax', order.tax), const Divider(height: 22), _row('Total', order.total, bold: true)]);
  Widget _row(String label, num amount, {bool bold = false}) => Padding(padding: const EdgeInsets.symmetric(vertical: 3), child: Row(children: [Expanded(child: Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w600))), Text(_money(amount), style: TextStyle(fontWeight: bold ? FontWeight.w900 : FontWeight.w700, color: bold ? AppColors.primary : null))]));
}

class _NoteCard extends StatelessWidget { final String note; const _NoteCard({required this.note}); @override Widget build(BuildContext context) => _InfoCard(icon: Icons.sticky_note_2_rounded, title: 'Order Note', children: [Text(note)]); }

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final List<Widget> children;
  const _InfoCard({required this.icon, required this.title, required this.children});
  @override Widget build(BuildContext context) => Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(24), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.18))), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Row(children: [Icon(icon, color: Theme.of(context).colorScheme.primary), const SizedBox(width: 8), Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900))]), const SizedBox(height: 12), ...children]));
}

String _money(num value) => '৳${value % 1 == 0 ? value.toInt() : value.toStringAsFixed(2)}';
String _label(String value) => value.trim().isEmpty ? 'Unknown' : value.replaceAll('_', ' ').split(' ').map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}').join(' ');
String _date(DateTime? date) { if (date == null) return 'Date unavailable'; const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']; final local = date.toLocal(); return '${months[local.month - 1]} ${local.day}, ${local.year}'; }
Color _statusColor(String status, Color fallback) { switch (status.toLowerCase()) { case 'paid': case 'delivered': case 'completed': return AppColors.success; case 'cancelled': case 'failed': return AppColors.error; case 'pending': case 'processing': return AppColors.warning; default: return fallback; } }
