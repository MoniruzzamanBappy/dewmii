import 'package:dewmii/features/admin/user_management/screens/admin_user_role_screen.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_user_model.dart';
import '../services/admin_user_api_service.dart';
import '../widgets/admin_recent_order_tile.dart';

class AdminCustomerDetailsScreen extends StatefulWidget {
  final int userId;
  final AdminUserListItemModel fallbackUser;

  const AdminCustomerDetailsScreen({
    super.key,
    required this.userId,
    required this.fallbackUser,
  });

  @override
  State<AdminCustomerDetailsScreen> createState() =>
      _AdminCustomerDetailsScreenState();
}

class _AdminCustomerDetailsScreenState extends State<AdminCustomerDetailsScreen>
    with SingleTickerProviderStateMixin {
  final AdminUserApiService service = AdminUserApiService();
  late final AnimationController _controller;
  late final Animation<double> _fade;

  bool isLoading = true;
  bool isActionLoading = false;
  AdminUserDetailsModel? user;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    fetchDetails();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchDetails() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getUserDetails(widget.userId);
      if (!mounted) return;
      setState(() => user = result);
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

  AdminUserListItemModel get listUser {
    final details = user;
    if (details == null) return widget.fallbackUser;
    return widget.fallbackUser.copyWith(
      role: details.role,
      status: details.status,
    );
  }

  Future<void> updateStatus() async {
    final details = user;
    if (details == null) return;
    final nextStatus = details.status == 'blocked' ? 'active' : 'blocked';
    setState(() => isActionLoading = true);
    try {
      final response = await service.updateStatus(
        userId: details.id,
        status: nextStatus,
        reason: nextStatus == 'blocked'
            ? 'Suspicious activity'
            : 'Account reviewed',
      );
      final updatedStatus = service.parseUpdatedStatus(response) ?? nextStatus;
      if (!mounted) return;
      setState(() => user = details.copyWith(status: updatedStatus));
      AppToast.show(
        context,
        message: response['message']?.toString() ??
            'User status updated successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> openRoleScreen() async {
    final updatedUser = await Navigator.push<AdminUserListItemModel>(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, _) => AdminUserRoleScreen(user: listUser),
        transitionsBuilder: (_, animation, _, child) => FadeTransition(
          opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        ),
      ),
    );
    if (updatedUser != null && user != null) {
      setState(() => user = user!.copyWith(role: updatedUser.role));
    }
  }

  @override
  Widget build(BuildContext context) {
    final details = user;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Details'),
        actions: [
          IconButton(
            onPressed: openRoleScreen,
            icon: const Icon(Icons.admin_panel_settings_rounded),
          ),
        ],
      ),
      body: isLoading
          ? const _DetailsSkeleton()
          : details == null
              ? _EmptyDetails(onRetry: fetchDetails)
              : RefreshIndicator(
                  onRefresh: fetchDetails,
                  child: FadeTransition(
                    opacity: _fade,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                      children: [
                        if (isActionLoading) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: 14),
                        ],
                        _ProfileCard(details: details),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: updateStatus,
                                icon: Icon(
                                  details.status == 'blocked'
                                      ? Icons.lock_open_rounded
                                      : Icons.block_rounded,
                                ),
                                label: Text(
                                  details.status == 'blocked'
                                      ? 'Unblock'
                                      : 'Block',
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: FilledButton.icon(
                                onPressed: openRoleScreen,
                                icon: const Icon(
                                  Icons.admin_panel_settings_rounded,
                                ),
                                label: const Text('Role'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        _StatsGrid(details: details),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Addresses',
                          icon: Icons.location_on_rounded,
                          child: details.addresses.isEmpty
                              ? const _InlineEmpty(text: 'No addresses found')
                              : Column(
                                  children: details.addresses
                                      .map((address) => _AddressRow(address: address))
                                      .toList(),
                                ),
                        ),
                        const SizedBox(height: 16),
                        _InfoCard(
                          title: 'Recent Orders',
                          icon: Icons.receipt_long_rounded,
                          child: details.recentOrders.isEmpty
                              ? const _InlineEmpty(text: 'No recent orders found')
                              : Column(
                                  children: details.recentOrders
                                      .map((order) => AdminRecentOrderTile(order: order))
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

class _ProfileCard extends StatelessWidget {
  final AdminUserDetailsModel details;
  const _ProfileCard({required this.details});

  @override
  Widget build(BuildContext context) {
    final statusColor = details.status == 'active'
        ? AppColors.success
        : AppColors.error;
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(32),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundColor: Colors.white.withValues(alpha: 0.20),
            backgroundImage: details.avatarUrl == null
                ? null
                : NetworkImage(details.avatarUrl!),
            child: details.avatarUrl == null
                ? Text(
                    details.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w900,
                    ),
                  )
                : null,
          ),
          const SizedBox(height: 14),
          Text(
            details.displayName,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            details.email,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.86),
              fontWeight: FontWeight.w600,
            ),
          ),
          if (details.phoneNumber.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              details.phoneNumber,
              style: TextStyle(color: Colors.white.withValues(alpha: 0.82)),
            ),
          ],
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              _Badge(
                label: details.role,
                color: Colors.white,
                foreground: AppColors.primary,
              ),
              _Badge(
                label: details.status,
                color: statusColor,
                foreground: Colors.white,
              ),
              if (details.emailVerified)
                const _Badge(
                  label: 'Verified',
                  color: AppColors.success,
                  foreground: Colors.white,
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsGrid extends StatelessWidget {
  final AdminUserDetailsModel details;
  const _StatsGrid({required this.details});

  @override
  Widget build(BuildContext context) => GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.65,
        children: [
          _StatCard(
            label: 'Orders',
            value: '${details.totalOrders}',
            icon: Icons.shopping_bag_rounded,
            color: AppColors.primary,
          ),
          _StatCard(
            label: 'Spent',
            value: '৳${details.totalSpent}',
            icon: Icons.payments_rounded,
            color: AppColors.success,
          ),
          _StatCard(
            label: 'Verified',
            value: details.emailVerified ? 'Yes' : 'No',
            icon: Icons.verified_rounded,
            color: AppColors.info,
          ),
          _StatCard(
            label: 'Joined',
            value: details.createdAt == null ? '-' : '${details.createdAt!.year}',
            icon: Icons.calendar_month_rounded,
            color: AppColors.warning,
          ),
        ],
      );
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),
          Text(label, maxLines: 1, overflow: TextOverflow.ellipsis),
        ],
      ),
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;
  const _InfoCard({required this.title, required this.icon, required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.all(18),
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
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
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

class _AddressRow extends StatelessWidget {
  final AdminUserAddressModel address;
  const _AddressRow({required this.address});

  @override
  Widget build(BuildContext context) => Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              address.isDefault ? Icons.home_rounded : Icons.location_on_rounded,
              color: AppColors.primary,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          address.name,
                          style: const TextStyle(fontWeight: FontWeight.w900),
                        ),
                      ),
                      if (address.isDefault) const _SmallPill(text: 'Default'),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(address.phone),
                  const SizedBox(height: 2),
                  Text(address.fullAddress),
                ],
              ),
            ),
          ],
        ),
      );
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;
  final Color foreground;
  const _Badge({required this.label, required this.color, required this.foreground});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(999)),
        child: Text(
          label.replaceAll('_', ' ').toUpperCase(),
          style: TextStyle(
            color: foreground,
            fontWeight: FontWeight.w900,
            fontSize: 11,
          ),
        ),
      );
}

class _SmallPill extends StatelessWidget {
  final String text;
  const _SmallPill({required this.text});

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: AppColors.success.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(999),
        ),
        child: Text(
          text,
          style: const TextStyle(
            color: AppColors.success,
            fontSize: 11,
            fontWeight: FontWeight.w900,
          ),
        ),
      );
}

class _InlineEmpty extends StatelessWidget {
  final String text;
  const _InlineEmpty({required this.text});

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(12),
        child: Center(child: Text(text)),
      );
}

class _EmptyDetails extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyDetails({required this.onRetry});

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person_off_outlined, size: 70, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text(
              'User details not found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 12),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
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
            height: index == 0 ? 210 : 100,
            decoration: BoxDecoration(
              color: AppColors.shimmerBase.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(index == 0 ? 32 : 24),
            ),
          ),
        ),
      );
}
