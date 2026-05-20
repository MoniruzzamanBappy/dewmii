import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../order/screens/order_details_screen.dart';
import '../models/notification_model.dart';
import '../services/notification_api_service.dart';

class NotificationDetailsScreen extends StatefulWidget {
  final int notificationId;

  const NotificationDetailsScreen({super.key, required this.notificationId});

  @override
  State<NotificationDetailsScreen> createState() =>
      _NotificationDetailsScreenState();
}

class _NotificationDetailsScreenState extends State<NotificationDetailsScreen> {
  final NotificationApiService service = NotificationApiService();

  bool isLoading = true;
  NotificationModel? notification;

  Future<void> fetchDetails() async {
    try {
      final result = await service.getNotificationDetails(widget.notificationId);

      if (!mounted) return;

      setState(() {
        notification = result;
      });
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: _cleanError(error),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  void handleAction(NotificationModel item) {
    final action = item.action;
    if (action == null) return;

    if (action.screen == 'order_details') {
      final orderId = _asInt(action.params['order_id'] ?? action.params['id']);

      if (orderId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(orderId: orderId),
          ),
        );
      }
    }
  }

  int? _asInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value.toString());
  }

  String _cleanError(Object error) {
    return error
        .toString()
        .replaceAll('Exception: ', '')
        .replaceAll(RegExp(r'ApiException\([^)]*\):\s*'), '');
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    final item = notification;
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final background =
        isDark ? AppColors.darkBackground : AppColors.lightBackground;
    final textColor =
        isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
    final mutedText =
        isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(title: const Text('Notification Details')),
      body: isLoading
          ? const _DetailsSkeleton()
          : item == null
              ? _NotFoundState(textColor: textColor, mutedText: mutedText)
              : ListView(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
                  children: [
                    _DetailsHero(item: item),
                    const SizedBox(height: 18),
                    _MessageCard(item: item),
                    if (item.action != null) ...[
                      const SizedBox(height: 22),
                      ElevatedButton.icon(
                        onPressed: () => handleAction(item),
                        icon: const Icon(Icons.open_in_new_rounded),
                        label: Text(item.action!.label.isEmpty
                            ? 'Open details'
                            : item.action!.label),
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(54),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(18),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
    );
  }
}

class _DetailsHero extends StatelessWidget {
  final NotificationModel item;

  const _DetailsHero({required this.item});

  IconData get icon {
    switch (item.type) {
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
    switch (item.type) {
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
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 520),
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
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
          borderRadius: BorderRadius.circular(32),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: isDark ? 0.26 : 0.18),
              blurRadius: 34,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -18,
              top: -18,
              child: Icon(
                icon,
                size: 128,
                color: Colors.white.withValues(alpha: 0.16),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 62,
                  height: 62,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.22),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: Colors.white, size: 30),
                ),
                const SizedBox(height: 18),
                Text(
                  item.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children: [
                    _StatusPill(
                      text: item.displayType,
                      icon: icon,
                      color: color,
                    ),
                    _StatusPill(
                      text: item.isRead ? 'Read' : 'Unread',
                      icon: item.isRead
                          ? Icons.mark_email_read_rounded
                          : Icons.mark_email_unread_rounded,
                      color: item.isRead ? AppColors.success : AppColors.primary,
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageCard extends StatelessWidget {
  final NotificationModel item;

  const _MessageCard({required this.item});

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

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: surface,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.22 : 0.06),
            blurRadius: 26,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Message',
            style: theme.textTheme.titleMedium?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            item.message,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: mutedText,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 20),
          const Divider(height: 1),
          const SizedBox(height: 18),
          _InfoRow(
            icon: Icons.category_rounded,
            label: 'Type',
            value: item.displayType,
          ),
          if (item.createdAt != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.schedule_rounded,
              label: 'Received',
              value: _formatDate(item.createdAt!),
            ),
          ],
          if (item.readAt != null) ...[
            const SizedBox(height: 12),
            _InfoRow(
              icon: Icons.done_all_rounded,
              label: 'Read at',
              value: _formatDate(item.readAt!),
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final local = date.toLocal();
    final day = local.day.toString().padLeft(2, '0');
    final month = local.month.toString().padLeft(2, '0');
    final hour = local.hour.toString().padLeft(2, '0');
    final minute = local.minute.toString().padLeft(2, '0');

    return '$day/$month/${local.year} at $hour:$minute';
  }
}

class _StatusPill extends StatelessWidget {
  final String text;
  final IconData icon;
  final Color color;

  const _StatusPill({
    required this.text,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.20),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: Colors.white),
          const SizedBox(width: 6),
          Text(
            text,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 19, color: AppColors.primary),
        const SizedBox(width: 10),
        Text(
          '$label:',
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _DetailsSkeleton extends StatelessWidget {
  const _DetailsSkeleton();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkSurfaceVariant : AppColors.softMuted;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Container(
          height: 230,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(32),
          ),
        ),
        const SizedBox(height: 18),
        Container(
          height: 240,
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
            ),
          ),
        ),
      ],
    );
  }
}

class _NotFoundState extends StatelessWidget {
  final Color textColor;
  final Color mutedText;

  const _NotFoundState({
    required this.textColor,
    required this.mutedText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.notifications_off_rounded,
              size: 86,
              color: AppColors.primary.withValues(alpha: 0.7),
            ),
            const SizedBox(height: 18),
            Text(
              'Notification not found',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: textColor,
                    fontWeight: FontWeight.w900,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'This notification may have been deleted or is no longer available.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: mutedText,
                    height: 1.45,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}
