import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/admin_customer_analytics_model.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_section_card.dart';
import '../widgets/admin_stat_card.dart';

class AdminCustomerAnalyticsScreen extends StatefulWidget {
  const AdminCustomerAnalyticsScreen({super.key});

  @override
  State<AdminCustomerAnalyticsScreen> createState() => _AdminCustomerAnalyticsScreenState();
}

class _AdminCustomerAnalyticsScreenState extends State<AdminCustomerAnalyticsScreen> with SingleTickerProviderStateMixin {
  final AdminApiService service = AdminApiService();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool isLoading = true;
  AdminCustomerAnalyticsModel? analytics;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 600));
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    fetchAnalytics();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchAnalytics() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getCustomerAnalytics();
      if (!mounted) return;
      setState(() => analytics = result);
      _controller.forward(from: 0);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final data = analytics;
    return Scaffold(
      appBar: AppBar(title: const Text('Customer Analytics')),
      body: isLoading
          ? const _AdminSkeleton()
          : data == null
              ? _AdminEmptyState(title: 'Customer analytics not found', onRetry: fetchAnalytics)
              : RefreshIndicator(
                  onRefresh: fetchAnalytics,
                  child: FadeTransition(
                    opacity: _fade,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      children: [
                        const _AnalyticsHero(title: 'Customer Growth', subtitle: 'Monitor new, returning and inactive customers', icon: Icons.people_alt_rounded, color: AppColors.info),
                        const SizedBox(height: 18),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.45,
                          children: [
                            AdminStatCard(title: 'Total Customers', value: '${data.totalCustomers}', icon: Icons.groups_rounded, color: AppColors.primary),
                            AdminStatCard(title: 'New Customers', value: '${data.newCustomers}', icon: Icons.person_add_rounded, color: AppColors.success),
                            AdminStatCard(title: 'Returning', value: '${data.returningCustomers}', icon: Icons.repeat_rounded, color: AppColors.warning),
                            AdminStatCard(title: 'Inactive', value: '${data.inactiveCustomers}', icon: Icons.person_off_rounded, color: AppColors.error),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AdminSectionCard(
                          title: 'Customer Growth Chart',
                          icon: Icons.show_chart_rounded,
                          child: data.chart.isEmpty
                              ? const _InlineEmpty(text: 'No customer chart data found')
                              : Column(children: data.chart.map((point) => _GrowthRow(point: point, total: data.newCustomers)).toList()),
                        ),
                        AdminSectionCard(
                          title: 'Top Customers',
                          icon: Icons.emoji_events_rounded,
                          child: data.topCustomers.isEmpty
                              ? const _InlineEmpty(text: 'No top customers found')
                              : Column(children: data.topCustomers.map((customer) => _CustomerRow(customer: customer)).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _GrowthRow extends StatelessWidget {
  final AdminCustomerChartModel point;
  final int total;
  const _GrowthRow({required this.point, required this.total});
  @override
  Widget build(BuildContext context) {
    final double percent = total <= 0 ? 0.05 : (point.newCustomers / total).clamp(0.05, 1).toDouble();
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [Expanded(child: Text(point.date, style: const TextStyle(fontWeight: FontWeight.w900))), Text('${point.newCustomers} new', style: const TextStyle(fontWeight: FontWeight.w900))]),
        const SizedBox(height: 7),
        ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: percent, minHeight: 8, backgroundColor: AppColors.info.withValues(alpha: 0.12), valueColor: const AlwaysStoppedAnimation<Color>(AppColors.info))),
      ]),
    );
  }
}

class _CustomerRow extends StatelessWidget {
  final AdminTopCustomerModel customer;
  const _CustomerRow({required this.customer});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(color: AppColors.primary.withValues(alpha: 0.07), borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: 0.14), child: Text(customer.name.isEmpty ? 'C' : customer.name[0].toUpperCase(), style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.w900))),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(customer.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text('${customer.email} • ${customer.totalOrders} orders', maxLines: 1, overflow: TextOverflow.ellipsis)])),
        Text('৳${customer.totalSpent}', style: const TextStyle(fontWeight: FontWeight.w900, color: AppColors.primary)),
      ]),
    );
  }
}

class _AnalyticsHero extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  const _AnalyticsHero({required this.title, required this.subtitle, required this.icon, required this.color});
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(30), boxShadow: [BoxShadow(color: color.withValues(alpha: 0.18), blurRadius: 28, offset: const Offset(0, 14))]),
        child: Row(children: [
          Container(padding: const EdgeInsets.all(14), decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(20)), child: Icon(icon, color: Colors.white, size: 30)),
          const SizedBox(width: 14),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(color: Colors.white, fontSize: 23, fontWeight: FontWeight.w900)), const SizedBox(height: 4), Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.84), fontWeight: FontWeight.w700))])),
        ]),
      );
}

class _InlineEmpty extends StatelessWidget { final String text; const _InlineEmpty({required this.text}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(18), child: Center(child: Text(text))); }
class _AdminEmptyState extends StatelessWidget { final String title; final VoidCallback onRetry; const _AdminEmptyState({required this.title, required this.onRetry}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.people_outline_rounded, size: 66, color: AppColors.primary), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 12), FilledButton(onPressed: onRetry, child: const Text('Try Again'))]))); }
class _AdminSkeleton extends StatelessWidget { const _AdminSkeleton(); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: List.generate(6, (index) => Container(margin: const EdgeInsets.only(bottom: 14), height: index == 0 ? 150 : 86, decoration: BoxDecoration(color: AppColors.shimmerBase.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(index == 0 ? 30 : 22))))); }
