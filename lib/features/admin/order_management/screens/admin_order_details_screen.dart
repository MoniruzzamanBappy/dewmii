import 'package:dewmii/features/admin/order_management/screens/admin_update_order_status_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_order_model.dart';
import '../services/admin_order_api_service.dart';
import '../widgets/admin_order_item_card.dart';

class AdminOrderDetailsScreen extends StatefulWidget {
  final int orderId;

  const AdminOrderDetailsScreen({super.key, required this.orderId});

  @override
  State<AdminOrderDetailsScreen> createState() =>
      _AdminOrderDetailsScreenState();
}

class _AdminOrderDetailsScreenState extends State<AdminOrderDetailsScreen> {
  final AdminOrderApiService service = AdminOrderApiService();

  bool isLoading = true;
  AdminOrderDetailsModel? order;

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  Future<void> fetchDetails() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getOrderDetails(widget.orderId);
      if (!mounted) return;
      setState(() => order = result);
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

  Future<void> openUpdate(AdminOrderDetailsModel details) async {
    final result = await Navigator.push<AdminOrderListItemModel>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => AdminUpdateOrderStatusScreen(
          order: AdminOrderListItemModel(
            id: details.id,
            orderNumber: details.orderNumber,
            customer: details.customer,
            status: details.status,
            paymentStatus: details.paymentStatus,
            paymentMethod: details.paymentMethod,
            total: details.total,
            itemsCount: details.items.length,
            createdAt: details.createdAt,
          ),
        ),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: child,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        order = details.copyWith(
          status: result.status,
          paymentStatus: result.paymentStatus,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final item = order;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order Details'),
        actions: [
          if (item != null)
            IconButton(
              onPressed: () => openUpdate(item),
              icon: const Icon(Icons.edit_note_rounded),
            ),
        ],
      ),
      body: isLoading
          ? const _DetailsSkeleton()
          : item == null
              ? _EmptyDetails(onRetry: fetchDetails)
              : RefreshIndicator(
                  onRefresh: fetchDetails,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                    children: [
                      _DetailsHero(item: item),
                      const SizedBox(height: 18),
                      _InfoCard(
                        title: 'Customer',
                        icon: Icons.person_outline_rounded,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _InfoLine(label: 'Name', value: item.customer.name),
                            _InfoLine(label: 'Phone', value: item.customer.phone),
                            _InfoLine(label: 'Email', value: item.customer.email),
                          ],
                        ),
                      ),
                      _InfoCard(
                        title: 'Shipping Address',
                        icon: Icons.location_on_outlined,
                        child: Text(
                          item.shippingAddress.fullAddress.isEmpty
                              ? 'No address found'
                              : item.shippingAddress.fullAddress,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      _InfoCard(
                        title: 'Items',
                        icon: Icons.inventory_2_outlined,
                        child: Column(
                          children: item.items.isEmpty
                              ? [const _InlineEmpty(text: 'No items found')]
                              : item.items
                                  .map((product) => AdminOrderItemCard(item: product))
                                  .toList(),
                        ),
                      ),
                      _InfoCard(
                        title: 'Payment Summary',
                        icon: Icons.payments_outlined,
                        child: Column(
                          children: [
                            _AmountRow(label: 'Subtotal', value: item.subtotal),
                            _AmountRow(label: 'Discount', value: item.discount),
                            _AmountRow(label: 'Shipping', value: item.shippingCharge),
                            _AmountRow(label: 'Tax', value: item.tax),
                            const Divider(height: 22),
                            _AmountRow(
                              label: 'Total',
                              value: item.total,
                              isTotal: true,
                            ),
                          ],
                        ),
                      ),
                      _InfoCard(
                        title: 'Status History',
                        icon: Icons.timeline_rounded,
                        child: Column(
                          children: item.statusHistory.isEmpty
                              ? [const _InlineEmpty(text: 'No history found')]
                              : item.statusHistory
                                  .map((history) => _TimelineRow(history: history))
                                  .toList(),
                        ),
                      ),
                      if (item.note.trim().isNotEmpty)
                        _InfoCard(
                          title: 'Order Note',
                          icon: Icons.sticky_note_2_outlined,
                          child: Text(item.note),
                        ),
                    ],
                  ),
                ),
    );
  }
}

class _DetailsHero extends StatelessWidget {
  final AdminOrderDetailsModel item;

  const _DetailsHero({required this.item});

  Color _statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'delivered':
      case 'completed':
        return AppColors.success;
      case 'cancelled':
      case 'failed':
        return AppColors.error;
      case 'pending':
      case 'processing':
        return AppColors.warning;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _statusColor(item.status);

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.20),
            blurRadius: 28,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            item.orderNumber,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            item.createdAt == null
                ? 'Created date unavailable'
                : 'Created ${item.createdAt!.day}/${item.createdAt!.month}/${item.createdAt!.year}',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroPill(label: item.status, color: statusColor),
              const SizedBox(width: 8),
              _HeroPill(label: item.paymentStatus, color: Colors.white),
              const Spacer(),
              Text(
                '৳${item.total}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroPill extends StatelessWidget {
  final String label;
  final Color color;

  const _HeroPill({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final foreground = color == Colors.white ? AppColors.primary : color;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: foreground == AppColors.primary ? Colors.white : Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _InfoCard({
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
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w900,
                ),
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

class _InfoLine extends StatelessWidget {
  final String label;
  final String value;

  const _InfoLine({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 7),
      child: Row(
        children: [
          SizedBox(
            width: 82,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Expanded(child: Text(value.isEmpty ? '-' : value)),
        ],
      ),
    );
  }
}

class _AmountRow extends StatelessWidget {
  final String label;
  final num value;
  final bool isTotal;

  const _AmountRow({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontWeight: isTotal ? FontWeight.w900 : FontWeight.w600,
                fontSize: isTotal ? 17 : 14,
              ),
            ),
          ),
          Text(
            '৳$value',
            style: TextStyle(
              color: isTotal ? AppColors.primary : null,
              fontWeight: FontWeight.w900,
              fontSize: isTotal ? 18 : 14,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineRow extends StatelessWidget {
  final AdminOrderStatusHistoryModel history;

  const _TimelineRow({required this.history});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 13,
            backgroundColor: AppColors.primary,
            child: Icon(Icons.check_rounded, size: 15, color: Colors.white),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  history.status.toUpperCase(),
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                if (history.note.isNotEmpty) ...[
                  const SizedBox(height: 3),
                  Text(history.note),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  final String text;

  const _InlineEmpty({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(10),
        child: Center(child: Text(text)),
      );
}

class _EmptyDetails extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyDetails({required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.receipt_long_outlined, size: 66, color: AppColors.primary),
              const SizedBox(height: 12),
              const Text(
                'Order not found',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 12),
              FilledButton(onPressed: onRetry, child: const Text('Try Again')),
            ],
          ),
        ),
      );
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(20),
        children: List.generate(
          5,
          (index) => Container(
            margin: const EdgeInsets.only(bottom: 14),
            height: index == 0 ? 170 : 120,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(index == 0 ? 30 : 24),
            ),
          ),
        ),
      );
}
