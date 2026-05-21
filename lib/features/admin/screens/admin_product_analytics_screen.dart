import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/admin_product_analytics_model.dart';
import '../services/admin_api_service.dart';
import '../widgets/admin_section_card.dart';
import '../widgets/admin_stat_card.dart';

class AdminProductAnalyticsScreen extends StatefulWidget {
  const AdminProductAnalyticsScreen({super.key});

  @override
  State<AdminProductAnalyticsScreen> createState() => _AdminProductAnalyticsScreenState();
}

class _AdminProductAnalyticsScreenState extends State<AdminProductAnalyticsScreen> with SingleTickerProviderStateMixin {
  final AdminApiService service = AdminApiService();
  late final AnimationController _controller;
  late final Animation<double> _fade;
  bool isLoading = true;
  AdminProductAnalyticsModel? analytics;

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
      final result = await service.getProductAnalytics();
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
      appBar: AppBar(title: const Text('Product Analytics')),
      body: isLoading
          ? const _AdminSkeleton()
          : data == null
              ? _AdminEmptyState(title: 'Product analytics not found', onRetry: fetchAnalytics)
              : RefreshIndicator(
                  onRefresh: fetchAnalytics,
                  child: FadeTransition(
                    opacity: _fade,
                    child: ListView(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      children: [
                        const _AnalyticsHero(title: 'Product Insights', subtitle: 'Top sellers, stock alerts and inventory health', icon: Icons.inventory_2_rounded, color: AppColors.warning),
                        const SizedBox(height: 18),
                        GridView.count(
                          crossAxisCount: 2,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          crossAxisSpacing: 14,
                          mainAxisSpacing: 14,
                          childAspectRatio: 1.45,
                          children: [
                            AdminStatCard(title: 'Top Sellers', value: '${data.topSellingProducts.length}', icon: Icons.local_fire_department_rounded, color: AppColors.success),
                            AdminStatCard(title: 'Low Stock', value: '${data.lowStockProducts.length}', icon: Icons.warning_amber_rounded, color: AppColors.warning),
                            AdminStatCard(title: 'Out of Stock', value: '${data.outOfStockProducts.length}', icon: Icons.remove_shopping_cart_rounded, color: AppColors.error),
                            AdminStatCard(title: 'Stock Alerts', value: '${data.lowStockProducts.length + data.outOfStockProducts.length}', icon: Icons.notifications_active_rounded, color: AppColors.primary),
                          ],
                        ),
                        const SizedBox(height: 18),
                        AdminSectionCard(
                          title: 'Top Selling Products',
                          icon: Icons.trending_up_rounded,
                          child: data.topSellingProducts.isEmpty
                              ? const _InlineEmpty(text: 'No top selling products found')
                              : Column(children: data.topSellingProducts.map((item) => _TopProductRow(product: item)).toList()),
                        ),
                        AdminSectionCard(
                          title: 'Low Stock Products',
                          icon: Icons.inventory_rounded,
                          child: data.lowStockProducts.isEmpty
                              ? const _InlineEmpty(text: 'No low stock products found')
                              : Column(children: data.lowStockProducts.map((item) => _StockProductRow(product: item, color: AppColors.warning)).toList()),
                        ),
                        AdminSectionCard(
                          title: 'Out of Stock Products',
                          icon: Icons.block_rounded,
                          child: data.outOfStockProducts.isEmpty
                              ? const _InlineEmpty(text: 'No out of stock products found')
                              : Column(children: data.outOfStockProducts.map((item) => _StockProductRow(product: item, color: AppColors.error)).toList()),
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }
}

class _TopProductRow extends StatelessWidget {
  final AdminTopSellingProductModel product;
  const _TopProductRow({required this.product});
  @override
  Widget build(BuildContext context) => _ProductShell(
        title: product.name,
        subtitle: 'SKU ${product.sku} • ${product.soldQuantity} sold',
        trailing: '৳${product.revenue}',
        thumbnail: product.thumbnail,
        color: AppColors.success,
      );
}

class _StockProductRow extends StatelessWidget {
  final AdminStockProductModel product;
  final Color color;
  const _StockProductRow({required this.product, required this.color});
  @override
  Widget build(BuildContext context) => _ProductShell(
        title: product.name,
        subtitle: 'SKU ${product.sku} • ${product.stockStatus}',
        trailing: '${product.stock} left',
        thumbnail: product.thumbnail,
        color: color,
      );
}

class _ProductShell extends StatelessWidget {
  final String title;
  final String subtitle;
  final String trailing;
  final String thumbnail;
  final Color color;
  const _ProductShell({required this.title, required this.subtitle, required this.trailing, required this.thumbnail, required this.color});
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: color.withValues(alpha: 0.08), borderRadius: BorderRadius.circular(18)),
      child: Row(children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: thumbnail.isEmpty
              ? Container(width: 48, height: 48, color: color.withValues(alpha: 0.14), child: Icon(Icons.image_rounded, color: color))
              : Image.network(thumbnail, width: 48, height: 48, fit: BoxFit.cover, errorBuilder: (_, __, ___) => Container(width: 48, height: 48, color: color.withValues(alpha: 0.14), child: Icon(Icons.image_rounded, color: color))),
        ),
        const SizedBox(width: 12),
        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, maxLines: 1, overflow: TextOverflow.ellipsis)])),
        const SizedBox(width: 8),
        Text(trailing, style: TextStyle(fontWeight: FontWeight.w900, color: color)),
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
class _AdminEmptyState extends StatelessWidget { final String title; final VoidCallback onRetry; const _AdminEmptyState({required this.title, required this.onRetry}); @override Widget build(BuildContext context) => Center(child: Padding(padding: const EdgeInsets.all(24), child: Column(mainAxisSize: MainAxisSize.min, children: [const Icon(Icons.inventory_2_outlined, size: 66, color: AppColors.primary), const SizedBox(height: 12), Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900)), const SizedBox(height: 12), FilledButton(onPressed: onRetry, child: const Text('Try Again'))]))); }
class _AdminSkeleton extends StatelessWidget { const _AdminSkeleton(); @override Widget build(BuildContext context) => ListView(padding: const EdgeInsets.all(20), children: List.generate(6, (index) => Container(margin: const EdgeInsets.only(bottom: 14), height: index == 0 ? 150 : 86, decoration: BoxDecoration(color: AppColors.shimmerBase.withValues(alpha: 0.45), borderRadius: BorderRadius.circular(index == 0 ? 30 : 22))))); }
