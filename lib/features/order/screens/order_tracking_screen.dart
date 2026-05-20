import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../../shared/widgets/navigation/common_app_header.dart';
import '../models/order_tracking_model.dart';
import '../services/order_api_service.dart';
import '../widgets/tracking_timeline_item.dart';

class OrderTrackingScreen extends StatefulWidget {
  final int orderId;

  const OrderTrackingScreen({super.key, required this.orderId});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  final OrderApiService service = OrderApiService();
  bool isLoading = true;
  OrderTrackingModel? tracking;

  Future<void> fetchTracking() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getOrderTracking(widget.orderId);
      if (!mounted) return;
      setState(() => tracking = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppHeader(title: 'Track Order', showBackButton: true),
      body: isLoading ? _skeleton(context) : _body(context),
    );
  }

  Widget _body(BuildContext context) {
    final data = tracking;
    if (data == null) return Center(child: Text('Tracking information not found.', style: Theme.of(context).textTheme.titleMedium));

    return RefreshIndicator(
      onRefresh: fetchTracking,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          _TrackingHero(data: data),
          const SizedBox(height: 22),
          Text('Delivery Timeline', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 16),
          if (data.events.isEmpty)
            _EmptyTimeline()
          else
            Container(
              padding: const EdgeInsets.fromLTRB(14, 18, 14, 0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(26),
                border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.18)),
              ),
              child: Column(
                children: [
                  for (int i = 0; i < data.events.length; i++)
                    TrackingTimelineItem(event: data.events[i], isLast: i == data.events.length - 1),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _skeleton(BuildContext context) => ListView.builder(
        padding: const EdgeInsets.all(20),
        itemCount: 5,
        itemBuilder: (_, index) => Container(
          height: index == 0 ? 176 : 78,
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(26)),
        ),
      );
}

class _TrackingHero extends StatelessWidget {
  final OrderTrackingModel data;

  const _TrackingHero({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.24), blurRadius: 28, offset: const Offset(0, 16))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(data.orderNumber.isEmpty ? 'Order #${data.orderId}' : data.orderNumber, style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.w900))), const Icon(Icons.local_shipping_rounded, color: Colors.white, size: 36)]),
        const SizedBox(height: 8),
        Text(_label(data.currentStatus), style: TextStyle(color: Colors.white.withValues(alpha: 0.86), fontWeight: FontWeight.w700)),
        const SizedBox(height: 18),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.16), borderRadius: BorderRadius.circular(22)),
          child: Column(children: [
            _heroRow('Courier', data.courierName.isEmpty ? 'Not assigned yet' : data.courierName),
            const SizedBox(height: 8),
            _heroRow('Tracking No.', data.trackingNumber.isEmpty ? 'Pending' : data.trackingNumber),
            const SizedBox(height: 8),
            _heroRow('Estimated', _date(data.estimatedDeliveryDate)),
          ]),
        ),
      ]),
    );
  }

  Widget _heroRow(String label, String value) => Row(children: [Text(label, style: TextStyle(color: Colors.white.withValues(alpha: 0.7), fontWeight: FontWeight.w600)), const Spacer(), Flexible(child: Text(value, textAlign: TextAlign.end, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900)))]);
}

class _EmptyTimeline extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: Theme.of(context).cardColor, borderRadius: BorderRadius.circular(26), border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.18))),
      child: Column(children: [Icon(Icons.route_rounded, size: 48, color: Theme.of(context).colorScheme.primary), const SizedBox(height: 12), Text('No tracking updates yet', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)), const SizedBox(height: 6), Text('Timeline updates will appear here when your order moves.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodySmall)]),
    );
  }
}

String _label(String value) => value.trim().isEmpty ? 'Pending' : value.replaceAll('_', ' ').split(' ').map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}').join(' ');
String _date(DateTime? date) { if (date == null) return 'Not available'; const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec']; final local = date.toLocal(); return '${months[local.month - 1]} ${local.day}, ${local.year}'; }
