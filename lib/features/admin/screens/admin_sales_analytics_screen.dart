import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/admin_sales_analytics_model.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_section_card.dart';
import '../widgets/admin_stat_card.dart';

class AdminSalesAnalyticsScreen extends StatefulWidget {
  const AdminSalesAnalyticsScreen({super.key});

  @override
  State<AdminSalesAnalyticsScreen> createState() => _AdminSalesAnalyticsScreenState();
}

class _AdminSalesAnalyticsScreenState extends State<AdminSalesAnalyticsScreen> with SingleTickerProviderStateMixin {
  final AdminApiService service = AdminApiService();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool isLoading = true;
  AdminSalesAnalyticsModel? analytics;

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
      final result = await service.getSalesAnalytics();
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
      appBar: AppBar(title: const Text('Sales Analytics')),
      body: isLoading
          ? const _AdminSkeleton()
          : data == null
              ? _AdminEmptyState(title: 'Sales analytics not found', onRetry: fetchAnalytics)
              : RefreshIndicator(
                  onRefresh: fetchAnalytics,
                  child: FadeTransition(
                    opacity: _fade,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      children: [
                        _AnalyticsHero(title: 'Sales Performance', subtitle: '${data.filter.from} - ${data.filter.to}', icon: Icons.trending_up_rounded, color: AppColors.success),
                        const SizedBox(height: 18),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.45,
                          children: [
                            AdminStatCard(title: 'Total Sales', value: '৳${data.totalSales}', icon: Icons.payments_rounded, color: AppColors.success),
                            AdminStatCard(title: 'Orders', value: '${data.totalOrders}', icon: Icons.receipt_rounded, color: AppColors.primary),
                            AdminStatCard(title: 'Avg Order', value: '৳${data.averageOrderValue}', icon: Icons.stacked_line_chart_rounded, color: AppColors.warning),
                            AdminStatCard(title: 'Discount', value: '৳${data.totalDiscount}', icon: Icons.local_offer_rounded, color: AppColors.error),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AdminSectionCard(
                          title: 'Sales Chart',
                          icon: Icons.bar_chart_rounded,
                          child: data.chart.isEmpty
                              ? const _InlineEmpty(text: 'No chart data found')
                              : Column(children: data.chart.map((point) => _ProgressRow(label: point.date, value: '৳${point.sales}', note: '${point.orders} orders', percent: _percent(point.sales, data.totalSales), color: AppColors.success)).toList()),
                        ),
                        AdminSectionCard(
                          title: 'Payment Breakdown',
                          icon: Icons.credit_card_rounded,
                          child: data.paymentBreakdown.isEmpty
                              ? const _InlineEmpty(text: 'No payment data found')
                              : Column(children: data.paymentBreakdown.map((payment) => _ProgressRow(label: payment.paymentMethod.toUpperCase(), value: '৳${payment.amount}', note: '${payment.orders} orders', percent: _percent(payment.amount, data.totalSales), color: AppColors.primary)).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

double _percent(num value, num total) {
  if (total <= 0) return 0.05;
  final result = value / total;
  if (result < 0.05) return 0.05;
  if (result > 1) return 1;
  return result.toDouble();
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

class _ProgressRow extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  final double percent;
  final Color color;
  const _ProgressRow({required this.label, required this.value, required this.note, required this.percent, required this.color});
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w900))), Text(value, style: const TextStyle(fontWeight: FontWeight.w900))]),
          const SizedBox(height: 6),
          ClipRRect(borderRadius: BorderRadius.circular(999), child: LinearProgressIndicator(value: percent, minHeight: 8, backgroundColor: color.withValues(alpha: 0.12), valueColor: AlwaysStoppedAnimation<Color>(color))),
          const SizedBox(height: 4),
          Text(note, style: TextStyle(color: Theme.of(context).brightness == Brightness.dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary, fontSize: 12)),
        ]),
      );
}

class _InlineEmpty extends StatelessWidget { final String text; const _InlineEmpty({required this.text}); @override Widget build(BuildContext context) => Padding(padding: const EdgeInsets.all(18), child: Center(child: Text(text))); }
class _AdminEmptyState extends StatelessWidget { final String title; final VoidCallback onRetry; const _AdminEmptyState({required this.title, required this.onRetry}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.insights_outlined, size: 66, color: AppColors.primary), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 12), FilledButton(onPressed: onRetry, child: const Text('Try Again'))]))); }
class _AdminSkeleton extends StatelessWidget { const _AdminSkeleton(); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: List.generate(6, (index) => Container(margin: const EdgeInsets.only(bottom: 14), height: index == 0 ? 150 : 86, decoration: BoxDecoration(color: AppColors.shimmerBase.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(index == 0 ? 30 : 22))))); }
