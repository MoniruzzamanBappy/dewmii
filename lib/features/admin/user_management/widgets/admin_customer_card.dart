import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../models/admin_user_model.dart';

class AdminCustomerCard extends StatelessWidget {
  final AdminUserListItemModel user;
  final VoidCallback onTap;
  final VoidCallback onStatus;
  final VoidCallback onRole;

  const AdminCustomerCard({
    super.key,
    required this.user,
    required this.onTap,
    required this.onStatus,
    required this.onRole,
  });

  Color get _statusColor {
    switch (user.status.toLowerCase()) {
      case 'active':
        return AppColors.success;
      case 'blocked':
      case 'banned':
        return AppColors.error;
      case 'inactive':
        return AppColors.warning;
      default:
        return AppColors.muted;
    }
  }

  Color get _roleColor {
    switch (user.role.toLowerCase()) {
      case 'admin':
        return AppColors.primary;
      case 'manager':
        return AppColors.warning;
      default:
        return AppColors.success;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final secondary = isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.05),
            blurRadius: 18,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(24),
        child: InkWell(
          borderRadius: BorderRadius.circular(24),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 31,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.12),
                      backgroundImage: user.avatarUrl == null ? null : NetworkImage(user.avatarUrl!),
                      child: user.avatarUrl == null
                          ? Text(
                              user.initials,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w900,
                              ),
                            )
                          : null,
                    ),
                    const SizedBox(width: 13),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            user.email,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: secondary),
                          ),
                          if (user.phoneNumber.isNotEmpty) ...[
                            const SizedBox(height: 2),
                            Text(user.phoneNumber, style: TextStyle(color: secondary)),
                          ],
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right_rounded, color: secondary),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    _Badge(label: user.status, color: _statusColor),
                    _Badge(label: user.role, color: _roleColor),
                    _Badge(label: '${user.totalOrders} orders', color: AppColors.info),
                    _Badge(label: '৳${user.totalSpent}', color: AppColors.success),
                  ],
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: onStatus,
                        icon: Icon(user.status == 'blocked' ? Icons.lock_open_rounded : Icons.block_rounded),
                        label: Text(user.status == 'blocked' ? 'Unblock' : 'Block'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: onRole,
                        icon: const Icon(Icons.admin_panel_settings_rounded),
                        label: const Text('Role'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  final String label;
  final Color color;

  const _Badge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label.replaceAll('_', ' ').toUpperCase(),
        style: TextStyle(color: color, fontSize: 11, fontWeight: FontWeight.w900),
      ),
    );
  }
}
