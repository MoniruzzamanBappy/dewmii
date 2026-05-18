import 'package:dewmii/features/order/screens/cancel_order_screen.dart';
import 'package:dewmii/features/order/screens/order_details_screen.dart';
import 'package:dewmii/features/order/screens/order_tracking_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/order_list_item_model.dart';
import '../services/order_api_service.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  const MyOrdersScreen({super.key});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderApiService service = OrderApiService();

  bool isLoading = true;
  List<OrderListItemModel> orders = [];

  Future<void> fetchOrders() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getOrders();

      if (!mounted) return;

      setState(() {
        orders = result;
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

  Future<void> openCancel(OrderListItemModel order) async {
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
        orders = orders.map((item) {
          if (item.id == order.id) {
            return item.copyWith(status: 'cancelled');
          }

          return item;
        }).toList();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('My Orders')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchOrders,
              child: orders.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.receipt_long_outlined,
                          size: 94,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No orders yet',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Your placed orders will appear here.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: AppColors.lightTextSecondary),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        const Text(
                          'Recent Orders',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 14),
                        ...orders.map((order) {
                          return OrderCard(
                            order: order,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OrderDetailsScreen(orderId: order.id),
                                ),
                              );
                            },
                            onTrack: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      OrderTrackingScreen(orderId: order.id),
                                ),
                              );
                            },
                            onCancel: () {
                              openCancel(order);
                            },
                          );
                        }),
                      ],
                    ),
            ),
    );
  }
}
