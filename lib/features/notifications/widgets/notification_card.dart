import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/notification_model.dart';

class NotificationCard extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  IconData get icon {
    switch (notification.type) {
      case 'order':
        return Icons.receipt_long_rounded;
      case 'payment':
        return Icons.payment_rounded;
      case 'promotion':
        return Icons.local_offer_rounded;
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
        return AppColors.success;
      default:
        return AppColors.muted;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: notification.isRead
            ? AppColors.lightSurface
            : AppColors.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: notification.isRead
              ? AppColors.lightBorder
              : AppColors.primary.withValues(alpha: 0.25),
        ),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.12),
          child: Icon(icon, color: color),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: const TextStyle(fontWeight: FontWeight.w900),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 9,
                height: 9,
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            notification.message,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        trailing: IconButton(
          onPressed: onDelete,
          icon: const Icon(
            Icons.delete_outline_rounded,
            color: AppColors.error,
          ),
        ),
      ),
    );
  }
}
