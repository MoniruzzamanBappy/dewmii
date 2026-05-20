import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;
  final int index;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
    this.index = 0,
  });

  IconData get icon {
    switch (notification.type) {
      case 'order':
        return Icons.receipt_long_rounded;
      case 'payment':
        return Icons.account_balance_wallet_rounded;
      case 'promotion':
      case 'offer':
        return Icons.local_offer_rounded;
      case 'delivery':
      case 'shipping':
        return Icons.local_shipping_rounded;
      case 'security':
        return Icons.shield_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Color get color {
    switch (notification.type) {
      case 'order':
        return AppColors.primary;
      case 'payment':
        return AppColors.warning;
      case 'promotion':
      case 'offer':
        return AppColors.success;
      case 'delivery':
      case 'shipping':
        return AppColors.info;
      case 'security':
        return AppColors.error;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final surface = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 280 + (index.clamp(0, 8) * 45)),
      curve: Curves.easeOutCubic,
      tween: Tween(begin: 0, end: 1),
      builder: (context, value, child) {
        return Opacity(
          opacity: value,
          child: Transform.translate(
            offset: Offset(0, 18 * (1 - value)),
            child: child,
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: notification.isRead
                    ? surface
                    : AppColors.primary.withValues(alpha: isDark ? 0.16 : 0.08),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: notification.isRead
                      ? border
                      : AppColors.primary.withValues(alpha: 0.35),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
                    blurRadius: 24,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.13),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                notification.title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  color: textColor,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ),
                            if (!notification.isRead) ...[
                              const SizedBox(width: 8),
                              Container(
                                width: 9,
                                height: 9,
                                decoration: const BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                ),
                              ),
                            ],
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(
                          notification.message,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: mutedText,
                            height: 1.35,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            _NotificationPill(
                              text: notification.displayType,
                              icon: icon,
                              color: color,
                            ),
                            if (notification.shortDate.isNotEmpty)
                              _NotificationPill(
                                text: notification.shortDate,
                                icon: Icons.schedule_rounded,
                                color: AppColors.muted,
                              ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    tooltip: 'Delete',
                    onPressed: onDelete,
                    icon: const Icon(Icons.delete_outline_rounded),
                    color: AppColors.error,
                    style: IconButton.styleFrom(
                      backgroundColor: AppColors.error.withValues(alpha: 0.09),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationPill extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _NotificationPill({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
