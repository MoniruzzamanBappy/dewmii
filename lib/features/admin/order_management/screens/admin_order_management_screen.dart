import 'package:dewmii/features/admin/order_management/screens/admin_order_details_screen.dart';
import 'package:dewmii/features/admin/order_management/screens/admin_update_order_status_screen.dart';
import 'package:dewmii/shared/widgets/admin_navigation/admin_app_header.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_order_model.dart';
import '../services/admin_order_api_service.dart';
import '../widgets/admin_order_card.dart';

class AdminOrderManagementScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const AdminOrderManagementScreen({super.key, this.showCommonScaffold = true});

  @override
  State<AdminOrderManagementScreen> createState() =>
      _AdminOrderManagementScreenState();
}

class _AdminOrderManagementScreenState extends State<AdminOrderManagementScreen>
    with SingleTickerProviderStateMixin {
  final AdminOrderApiService service = AdminOrderApiService();
  final searchController = TextEditingController();

  late final AnimationController _controller;
  late final Animation<double> _fade;

  bool isLoading = true;
  List<AdminOrderListItemModel> orders = [];
  List<AdminOrderListItemModel> filteredOrders = [];
  String selectedStatus = 'all';

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 550),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    fetchOrders();
  }

  @override
  void dispose() {
    searchController.dispose();
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchOrders() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getOrders();
      if (!mounted) return;

      setState(() {
        orders = result;
        _applyFilters();
      });
      _controller.forward(from: 0);
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

  void searchOrders(String value) {
    setState(_applyFilters);
  }

  void _setStatus(String status) {
    setState(() {
      selectedStatus = status;
      _applyFilters();
    });
  }

  void _applyFilters() {
    final keyword = searchController.text.trim().toLowerCase();

    filteredOrders = orders.where((order) {
      final matchesSearch =
          keyword.isEmpty ||
          order.orderNumber.toLowerCase().contains(keyword) ||
          order.customer.name.toLowerCase().contains(keyword) ||
          order.customer.phone.toLowerCase().contains(keyword) ||
          order.status.toLowerCase().contains(keyword) ||
          order.paymentStatus.toLowerCase().contains(keyword);

      final matchesStatus =
          selectedStatus == 'all' ||
          order.status.toLowerCase() == selectedStatus;

      return matchesSearch && matchesStatus;
    }).toList();
  }

  Future<void> openUpdate(AdminOrderListItemModel order) async {
    final result = await Navigator.push<AdminOrderListItemModel>(
      context,
      _route(AdminUpdateOrderStatusScreen(order: order)),
    );

    if (result != null) {
      setState(() {
        orders = orders
            .map((item) => item.id == result.id ? result : item)
            .toList();
        _applyFilters();
      });
    }
  }

  Route<T> _route<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final pending = orders
        .where((order) => order.status.toLowerCase() == 'pending')
        .length;
    final processing = orders
        .where((order) => order.status.toLowerCase() == 'processing')
        .length;
    final delivered = orders
        .where((order) => order.status.toLowerCase() == 'delivered')
        .length;

    return Scaffold(
      appBar: AdminAppHeader(
        title: 'Orders',
        subtitle: 'Manage orders, payments and tracking',
        showBackButton: widget.showCommonScaffold,
      ),
      body: isLoading
          ? const _OrderSkeleton()
          : RefreshIndicator(
              onRefresh: fetchOrders,
              child: FadeTransition(
                opacity: _fade,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    _OrdersHero(
                      total: orders.length,
                      pending: pending,
                      processing: processing,
                      delivered: delivered,
                    ),
                    const SizedBox(height: 18),
                    TextField(
                      controller: searchController,
                      onChanged: searchOrders,
                      textInputAction: TextInputAction.search,
                      decoration: InputDecoration(
                        hintText: 'Search order, customer, phone or status',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  searchOrders('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChipButton(
                            label: 'All',
                            selected: selectedStatus == 'all',
                            onTap: () => _setStatus('all'),
                          ),
                          _FilterChipButton(
                            label: 'Pending',
                            selected: selectedStatus == 'pending',
                            onTap: () => _setStatus('pending'),
                          ),
                          _FilterChipButton(
                            label: 'Processing',
                            selected: selectedStatus == 'processing',
                            onTap: () => _setStatus('processing'),
                          ),
                          _FilterChipButton(
                            label: 'Delivered',
                            selected: selectedStatus == 'delivered',
                            onTap: () => _setStatus('delivered'),
                          ),
                          _FilterChipButton(
                            label: 'Cancelled',
                            selected: selectedStatus == 'cancelled',
                            onTap: () => _setStatus('cancelled'),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Orders',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${filteredOrders.length} found',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    if (filteredOrders.isEmpty)
                      const _InlineEmpty(text: 'No matching orders found')
                    else
                      ...filteredOrders.map(
                        (order) => AdminOrderCard(
                          order: order,
                          onTap: () {
                            Navigator.push(
                              context,
                              _route(
                                AdminOrderDetailsScreen(orderId: order.id),
                              ),
                            );
                          },
                          onUpdate: () => openUpdate(order),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _OrdersHero extends StatelessWidget {
  final int total;
  final int pending;
  final int processing;
  final int delivered;

  const _OrdersHero({
    required this.total,
    required this.pending,
    required this.processing,
    required this.delivered,
  });

  @override
  Widget build(BuildContext context) {
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
          const Row(
            children: [
              Icon(Icons.shopping_bag_rounded, color: Colors.white),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Manage customer orders',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              _HeroMetric(label: 'Total', value: '$total'),
              _HeroMetric(label: 'Pending', value: '$pending'),
              _HeroMetric(label: 'Processing', value: '$processing'),
              _HeroMetric(label: 'Delivered', value: '$delivered'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroMetric extends StatelessWidget {
  final String label;
  final String value;

  const _HeroMetric({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.82),
              fontWeight: FontWeight.w700,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChipButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: ChoiceChip(
        selected: selected,
        label: Text(label),
        onSelected: (_) => onTap(),
      ),
    );
  }
}

class _InlineEmpty extends StatelessWidget {
  final String text;

  const _InlineEmpty({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: Text(text, style: const TextStyle(fontWeight: FontWeight.w700)),
      ),
    );
  }
}

class _OrderSkeleton extends StatelessWidget {
  const _OrderSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: index == 0 ? 170 : 112,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(index == 0 ? 30 : 24),
          ),
        ),
      ),
    );
  }
}
