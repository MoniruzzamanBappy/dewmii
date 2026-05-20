import 'package:dewmii/features/order/screens/cancel_order_screen.dart';
import 'package:dewmii/features/order/screens/order_details_screen.dart';
import 'package:dewmii/features/order/screens/order_tracking_screen.dart';
import 'package:dewmii/shared/widgets/navigation/common_app_header.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/order_list_item_model.dart';
import '../services/order_api_service.dart';
import '../widgets/order_card.dart';

class MyOrdersScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const MyOrdersScreen({super.key, this.showCommonScaffold = true});

  @override
  State<MyOrdersScreen> createState() => _MyOrdersScreenState();
}

class _MyOrdersScreenState extends State<MyOrdersScreen> {
  final OrderApiService service = OrderApiService();

  bool isLoading = true;
  List<OrderListItemModel> orders = [];

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getOrders();
      if (!mounted) return;
      setState(() => orders = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> openCancel(OrderListItemModel order) async {
    final cancelled = await Navigator.push<bool>(
      context,
      _slideRoute(CancelOrderScreen(orderId: order.id, orderNumber: order.orderNumber)),
    );

    if (cancelled == true) {
      setState(() {
        orders = orders.map((item) => item.id == order.id ? item.copyWith(status: 'cancelled') : item).toList();
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
    final body = isLoading ? _buildSkeleton(context) : _buildContent(context);

    return Scaffold(
      appBar: CommonAppHeader(title: 'My Orders', showBackButton: widget.showCommonScaffold),
      body: body,
    );
  }

  Widget _buildContent(BuildContext context) {
    if (orders.isEmpty) {
      return RefreshIndicator(onRefresh: fetchOrders, child: _EmptyOrders());
    }

    return RefreshIndicator(
      onRefresh: fetchOrders,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        children: [
          _OrdersHero(totalOrders: orders.length, activeOrders: orders.where((item) => !['delivered', 'cancelled'].contains(item.status.toLowerCase())).length),
          const SizedBox(height: 20),
          Text('Recent Orders', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 14),
          ...orders.map((order) => OrderCard(
                order: order,
                onTap: () => Navigator.push(context, _slideRoute(OrderDetailsScreen(orderId: order.id))),
                onTrack: () => Navigator.push(context, _slideRoute(OrderTrackingScreen(orderId: order.id))),
                onCancel: () => openCancel(order),
              )),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) {
    final theme = Theme.of(context);
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (_, index) => Container(
        height: index == 0 ? 150 : 176,
        margin: const EdgeInsets.only(bottom: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.primary.withValues(alpha: 0.07),
          borderRadius: BorderRadius.circular(26),
        ),
      ),
    );
  }

  Route<T> _slideRoute<T>(Widget page) => PageRouteBuilder<T>(
        pageBuilder: (_, __, ___) => page,
        transitionDuration: const Duration(milliseconds: 260),
        transitionsBuilder: (_, animation, __, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.06, 0.02), end: Offset.zero).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic)),
              child: child,
            ),
          );
        },
      );
}

class _OrdersHero extends StatelessWidget {
  final int totalOrders;
  final int activeOrders;

  const _OrdersHero({required this.totalOrders, required this.activeOrders});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [BoxShadow(color: AppColors.primary.withValues(alpha: 0.25), blurRadius: 28, offset: const Offset(0, 16))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Track every purchase', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                const SizedBox(height: 7),
                Text('$activeOrders active orders from $totalOrders total', style: TextStyle(color: Colors.white.withValues(alpha: 0.82), fontWeight: FontWeight.w600)),
              ],
            ),
          ),
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(22)),
            child: const Icon(Icons.local_mall_rounded, color: Colors.white, size: 32),
          ),
        ],
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(28),
      children: [
        const SizedBox(height: 110),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.88, end: 1),
          duration: const Duration(milliseconds: 650),
          curve: Curves.elasticOut,
          builder: (_, value, child) => Transform.scale(scale: value, child: child),
          child: CircleAvatar(
            radius: 54,
            backgroundColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
            child: Icon(Icons.receipt_long_outlined, size: 58, color: Theme.of(context).colorScheme.primary),
          ),
        ),
        const SizedBox(height: 22),
        Text('No orders yet', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
        const SizedBox(height: 8),
        Text('Your placed orders will appear here with tracking and invoice details.', textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: Theme.of(context).textTheme.bodyMedium?.color?.withValues(alpha: 0.62))),
      ],
    );
  }
}
