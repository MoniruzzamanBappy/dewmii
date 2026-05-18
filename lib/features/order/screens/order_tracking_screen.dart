import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
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
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getOrderTracking(widget.orderId);

      if (!mounted) return;

      setState(() {
        tracking = result;
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

  @override
  void initState() {
    super.initState();
    fetchTracking();
  }

  @override
  Widget build(BuildContext context) {
    final data = tracking;

    return Scaffold(
      appBar: AppBar(title: const Text('Order Tracking')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data == null
          ? const Center(child: Text('Tracking not found'))
          : RefreshIndicator(
              onRefresh: fetchTracking,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(22),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.orderNumber,
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Current Status: ${data.currentStatus.toUpperCase()}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Courier: ${data.courierName}',
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          'Tracking No: ${data.trackingNumber}',
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Tracking Timeline',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 16),
                  ...List.generate(data.events.length, (index) {
                    return TrackingTimelineItem(
                      event: data.events[index],
                      isLast: index == data.events.length - 1,
                    );
                  }),
                ],
              ),
            ),
    );
  }
}
