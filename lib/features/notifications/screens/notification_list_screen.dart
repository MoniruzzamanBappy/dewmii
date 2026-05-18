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
    setState(() {
      isLoading = true;
    });

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
        message: error.toString().replaceAll('Exception: ', ''),
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
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.markAllAsReadDemo();

      if (!mounted) return;

      setState(() {
        notifications = notifications.map((item) {
          return item.copyWith(isRead: true, readAt: DateTime.now());
        }).toList();

        unreadCount = 0;
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'All notifications marked as read',
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
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> deleteNotification(NotificationModel notification) async {
    setState(() {
      isActionLoading = true;
    });

    try {
      final response = await service.deleteNotificationDemo(
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
        message: response['message'] ?? 'Notification deleted successfully',
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
      if (mounted) {
        setState(() {
          isActionLoading = false;
        });
      }
    }
  }

  Future<void> openNotification(NotificationModel notification) async {
    await service.markAsReadDemo(notificationId: notification.id);

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

    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) =>
            NotificationDetailsScreen(notificationId: notification.id),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Notifications ($unreadCount)'),
        actions: [
          TextButton(
            onPressed: isActionLoading || unreadCount == 0
                ? null
                : markAllAsRead,
            child: const Text('Read All'),
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchNotifications,
              child: notifications.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.notifications_off_rounded,
                          size: 94,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No notifications',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (isActionLoading) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: 14),
                        ],
                        ...notifications.map((notification) {
                          return NotificationCard(
                            notification: notification,
                            onTap: () {
                              openNotification(notification);
                            },
                            onDelete: () {
                              deleteNotification(notification);
                            },
                          );
                        }),
                      ],
                    ),
            ),
    );
  }
}
