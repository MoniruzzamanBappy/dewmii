import 'package:dewmii/shared/widgets/admin_navigation/admin_app_header.dart';
import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/admin_dashboard_model.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_section_card.dart';
import '../widgets/admin_stat_card.dart';
import 'admin_customer_analytics_screen.dart';
import 'admin_product_analytics_screen.dart';
import 'admin_sales_analytics_screen.dart';

class AdminDashboardScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const AdminDashboardScreen({super.key, this.showCommonScaffold = true});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen>
    with SingleTickerProviderStateMixin {
  final AdminApiService service = AdminApiService();

  late final AnimationController _controller;
  late final Animation<double> _fade;

  bool isLoading = true;
  AdminDashboardModel? dashboard;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    fetchDashboard();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchDashboard() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getDashboard();

      if (!mounted) return;

      setState(() => dashboard = result);
      _controller.forward(from: 0);
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  void _open(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => page,
        transitionsBuilder: (_, animation, _, child) {
          return FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0, 0.04),
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final data = dashboard;

    return Scaffold(
      appBar: AdminAppHeader(
        title: 'Admin Dashboard',
        subtitle: 'Sales, orders, users overview',
        showBackButton: widget.showCommonScaffold,
      ),
      body: isLoading
          ? const _AdminSkeleton()
          : data == null
          ? _AdminEmptyState(
              title: 'Dashboard not found',
              onRetry: fetchDashboard,
            )
          : RefreshIndicator(
              onRefresh: fetchDashboard,
              child: FadeTransition(
                opacity: _fade,
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    _DashboardHero(data: data),

                    const SizedBox(height: 18),

                    GridView.count(
                      crossAxisCount: 2,
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      crossAxisSpacing: 14,
                      mainAxisSpacing: 14,
                      childAspectRatio: 1.45,
                      children: [
                        AdminStatCard(
                          title: 'Total Sales',
                          value: '৳${data.summary.totalSales}',
                          icon: Icons.payments_rounded,
                          color: AppColors.success,
                        ),
                        AdminStatCard(
                          title: 'Orders',
                          value: '${data.summary.totalOrders}',
                          icon: Icons.receipt_long_rounded,
                          color: AppColors.primary,
                        ),
                        AdminStatCard(
                          title: 'Customers',
                          value: '${data.summary.totalCustomers}',
                          icon: Icons.groups_rounded,
                          color: AppColors.info,
                        ),
                        AdminStatCard(
                          title: 'Low Stock',
                          value: '${data.summary.lowStockProducts}',
                          icon: Icons.inventory_2_rounded,
                          color: AppColors.warning,
                        ),
                      ],
                    ),

                    const SizedBox(height: 18),

                    AdminSectionCard(
                      title: 'Managements',
                      icon: Icons.admin_panel_settings_rounded,
                      child: Column(
                        children: [
                          _ActionTile(
                            icon: Icons.inventory_2_rounded,
                            title: 'Product Management',
                            subtitle:
                                'Manage products, stock, pricing and images',
                            color: AppColors.primary,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminProducts,
                              );
                            },
                          ),
                          _ActionTile(
                            icon: Icons.category_rounded,
                            title: 'Category Management',
                            subtitle: 'Manage categories and subcategories',
                            color: AppColors.info,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminCategories,
                              );
                            },
                          ),
                          _ActionTile(
                            icon: Icons.receipt_long_rounded,
                            title: 'Order Management',
                            subtitle: 'Manage orders, payments and shipping',
                            color: AppColors.warning,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminOrders,
                              );
                            },
                          ),
                          _ActionTile(
                            icon: Icons.people_alt_rounded,
                            title: 'User Management',
                            subtitle: 'Manage users, roles and permissions',
                            color: AppColors.success,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.adminUsers,
                              );
                            },
                          ),
                        ],
                      ),
                    ),

                    AdminSectionCard(
                      title: 'Analytics',
                      icon: Icons.insights_rounded,
                      child: Column(
                        children: [
                          _ActionTile(
                            icon: Icons.trending_up_rounded,
                            title: 'Sales Analytics',
                            subtitle: 'Revenue, orders and payment breakdown',
                            color: AppColors.success,
                            onTap: () =>
                                _open(const AdminSalesAnalyticsScreen()),
                          ),
                          _ActionTile(
                            icon: Icons.inventory_rounded,
                            title: 'Product Analytics',
                            subtitle: 'Top sellers and low stock products',
                            color: AppColors.warning,
                            onTap: () =>
                                _open(const AdminProductAnalyticsScreen()),
                          ),
                          _ActionTile(
                            icon: Icons.people_alt_rounded,
                            title: 'Customer Analytics',
                            subtitle: 'New, returning and top customers',
                            color: AppColors.info,
                            onTap: () =>
                                _open(const AdminCustomerAnalyticsScreen()),
                          ),
                        ],
                      ),
                    ),

                    AdminSectionCard(
                      title: 'Recent Orders',
                      icon: Icons.shopping_bag_rounded,
                      child: Column(
                        children: data.recentOrders.isEmpty
                            ? [
                                const _InlineEmpty(
                                  text: 'No recent orders found',
                                ),
                              ]
                            : data.recentOrders
                                  .map((order) => _OrderRow(order: order))
                                  .toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _DashboardHero extends StatelessWidget {
  final AdminDashboardModel data;

  const _DashboardHero({required this.data});

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
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.dashboard_customize_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Text(
                  'Today at a glance',
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
              Expanded(
                child: _HeroMetric(
                  label: 'Sales',
                  value: '৳${data.today.sales}',
                ),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Orders',
                  value: '${data.today.orders}',
                ),
              ),
              Expanded(
                child: _HeroMetric(
                  label: 'Pending',
                  value: '${data.today.pendingOrders}',
                ),
              ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 19,
            fontWeight: FontWeight.w900,
          ),
        ),
        const SizedBox(height: 3),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.82),
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _ActionTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Material(
        color: color.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          borderRadius: BorderRadius.circular(18),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  backgroundColor: color.withValues(alpha: 0.14),
                  child: Icon(icon, color: color),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded, color: color),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderRow extends StatelessWidget {
  final AdminRecentOrderModel order;

  const _OrderRow({required this.order});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Row(
        children: [
          const Icon(Icons.receipt_long_rounded, color: AppColors.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.orderNumber,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                Text(
                  order.customerName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          Text(
            '৳${order.total}',
            style: const TextStyle(fontWeight: FontWeight.w900),
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
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18),
      child: Center(child: Text(text)),
    );
  }
}

class _AdminEmptyState extends StatelessWidget {
  final String title;
  final VoidCallback onRetry;

  const _AdminEmptyState({required this.title, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.admin_panel_settings_outlined,
              size: 66,
              color: AppColors.primary,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}

class _AdminSkeleton extends StatelessWidget {
  const _AdminSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: index == 0 ? 170 : 86,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.45),
            borderRadius: BorderRadius.circular(index == 0 ? 30 : 22),
          ),
        ),
      ),
    );
  }
}
