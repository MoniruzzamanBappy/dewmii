import 'package:dewmii/features/notifications/screens/notification_details_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/notification_model.dart';
import '../services/notification_api_service.dart';
import '../widgets/notification_card.dart';

class NotificationListScreen extends StatefulWidget {
  const NotificationListScreen({super.key});

  @override
  State<NotificationListScreen> createState() => _NotificationListScreenState();
}

class _NotificationListScreenState extends State<NotificationListScreen> {
  final NotificationApiService service = NotificationApiService();

  bool isLoading = true;
  bool isActionLoading = false;

  List<NotificationModel> notifications = [];
  int unreadCount = 0;

  Future<void> fetchNotifications() async {
    if (mounted) {
      setState(() {
        isLoading = true;
      });
    }

    try {
      final result = await service.getNotifications();

      if (!mounted) return;

      setState(() {
        notifications = result;
        unreadCount = result.where((item) => !item.isRead).length;
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

  Future<void> markAllAsRead() async {
    if (unreadCount == 0 || isActionLoading) return;

    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.markAllAsRead();

      if (!mounted) return;

      setState(() {
        notifications = notifications.map((item) {
          return item.copyWith(isRead: true, readAt: DateTime.now());
        }).toList();

        unreadCount = 0;
      });

      AppToast.show(
        context,
        message: response['message']?.toString() ??
            'All notifications marked as read',
        type: ToastType.success,
      );
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
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    final shouldDelete = await _confirmDelete(notification);
    if (shouldDelete != true || isActionLoading) return;

    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.deleteNotification(
        notificationId: notification.id,
      );

      final deletedId =
          service.parseDeletedNotificationId(response) ?? notification.id;

      if (!mounted) return;

      setState(() {
        notifications = notifications.where((item) {
          return item.id != deletedId;
        }).toList();

        unreadCount = notifications.where((item) => !item.isRead).length;
      });

      AppToast.show(
        context,
        message: response['message']?.toString() ??
            'Notification deleted successfully',
        type: ToastType.success,
      );
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
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> openNotification(NotificationModel notification) async {
    if (!notification.isRead) {
      try {
        await service.markAsRead(notificationId: notification.id);
      } catch (_) {
        // Keep navigation smooth even if the demo mark-read endpoint fails.
      }

      if (!mounted) return;

      setState(() {
        notifications = notifications.map((item) {
          if (item.id == notification.id) {
            return item.copyWith(isRead: true, readAt: DateTime.now());
          }

          return item;
        }).toList();

        unreadCount = notifications.where((item) => !item.isRead).length;
      });
    }

    if (!mounted) return;

    await Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, secondaryAnimation) =>
            NotificationDetailsScreen(notificationId: notification.id),
        transitionsBuilder: (_, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          );

          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(0.05, 0.04),
                end: Offset.zero,
              ).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }

  Future<bool?> _confirmDelete(NotificationModel notification) {
    return showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (context) {
        final theme = Theme.of(context);

        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(22, 4, 22, 22),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: AppColors.error.withValues(alpha: 0.10),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    color: AppColors.error,
                  ),
                ),
                const SizedBox(height: 14),
                Text(
                  'Delete notification?',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  notification.title,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.pop(context, true),
                        icon: const Icon(Icons.delete_outline_rounded),
                        label: const Text('Delete'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
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
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
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
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: TextButton.icon(
              onPressed: isActionLoading || unreadCount == 0
                  ? null
                  : markAllAsRead,
              icon: isActionLoading
                  ? const SizedBox(
                      width: 15,
                      height: 15,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.done_all_rounded, size: 18),
              label: const Text('Read all'),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: fetchNotifications,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            SliverToBoxAdapter(
              child: _NotificationHero(
                unreadCount: unreadCount,
                totalCount: notifications.length,
                isLoading: isLoading,
              ),
            ),
            if (isActionLoading)
              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: LinearProgressIndicator(minHeight: 3),
                ),
              ),
            if (isLoading)
              const SliverPadding(
                padding: EdgeInsets.fromLTRB(20, 18, 20, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    _NotificationSkeleton.new,
                    childCount: 6,
                  ),
                ),
              )
            else if (notifications.isEmpty)
              SliverFillRemaining(
                hasScrollBody: false,
                child: _EmptyNotifications(
                  textColor: textColor,
                  mutedText: mutedText,
                ),
              )
            else
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 28),
                sliver: SliverList.builder(
                  itemCount: notifications.length,
                  itemBuilder: (context, index) {
                    final notification = notifications[index];

                    return NotificationCard(
                      index: index,
                      notification: notification,
                      onTap: () => openNotification(notification),
                      onDelete: () => deleteNotification(notification),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _NotificationHero extends StatelessWidget {
  final int unreadCount;
  final int totalCount;
  final bool isLoading;

  const _NotificationHero({
    required this.unreadCount,
    required this.totalCount,
    required this.isLoading,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.fromLTRB(20, 12, 20, 6),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.24 : 0.18),
            blurRadius: 30,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -16,
            top: -14,
            child: Icon(
              Icons.notifications_active_rounded,
              size: 120,
              color: Colors.white.withValues(alpha: 0.18),
            ),
          ),
          Row(
            children: [
              Container(
                width: 62,
                height: 62,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.notifications_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 550),
                  curve: Curves.easeOutCubic,
                  tween: Tween(begin: 0, end: 1),
                  builder: (context, value, child) {
                    return Opacity(
                      opacity: value,
                      child: Transform.translate(
                        offset: Offset(0, 12 * (1 - value)),
                        child: child,
                      ),
                    );
                  },
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isLoading
                            ? 'Loading inbox...'
                            : unreadCount == 0
                                ? 'You are all caught up'
                                : '$unreadCount unread notification${unreadCount == 1 ? '' : 's'}',
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$totalCount total notification${totalCount == 1 ? '' : 's'} in your inbox',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.86),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _NotificationSkeleton extends StatelessWidget {
  final BuildContext context;
  final int index;

  const _NotificationSkeleton(this.context, this.index);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final color = isDark ? AppColors.darkSurfaceVariant : AppColors.softMuted;

    return Container(
      height: 104,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Row(
        children: [
          _SkeletonBox(width: 52, height: 52, color: color, isCircle: true),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _SkeletonBox(width: 170, height: 15, color: color),
                const SizedBox(height: 12),
                _SkeletonBox(width: double.infinity, height: 12, color: color),
                const SizedBox(height: 8),
                _SkeletonBox(width: 130, height: 12, color: color),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SkeletonBox extends StatelessWidget {
  final double width;
  final double height;
  final Color color;
  final bool isCircle;

  const _SkeletonBox({
    required this.width,
    required this.height,
    required this.color,
    this.isCircle = false,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 900),
      tween: Tween(begin: 0.45, end: 1),
      curve: Curves.easeInOut,
      builder: (context, value, child) {
        return Opacity(opacity: value, child: child);
      },
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: color,
          shape: isCircle ? BoxShape.circle : BoxShape.rectangle,
          borderRadius: isCircle ? null : BorderRadius.circular(999),
        ),
      ),
    );
  }
}

class _EmptyNotifications extends StatelessWidget {
  final Color textColor;
  final Color mutedText;

  const _EmptyNotifications({
    required this.textColor,
    required this.mutedText,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(26),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder<double>(
            duration: const Duration(milliseconds: 650),
            curve: Curves.elasticOut,
            tween: Tween(begin: 0.75, end: 1),
            builder: (context, value, child) {
              return Transform.scale(scale: value, child: child);
            },
            child: Container(
              width: 112,
              height: 112,
              decoration: BoxDecoration(
                color: AppColors.primary.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_off_rounded,
                size: 56,
                color: AppColors.primary.withValues(alpha: 0.75),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'No notifications',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: textColor,
                  fontWeight: FontWeight.w900,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Order updates, offers, and account alerts will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: mutedText,
                  height: 1.45,
                ),
          ),
        ],
      ),
    );
  }
}
