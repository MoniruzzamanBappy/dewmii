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
      final result = await service.getNotificationDetails(
        widget.notificationId,
      );

      if (!mounted) return;

      setState(() {
        notification = result;
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

  void handleAction(NotificationModel item) {
    final action = item.action;

    if (action == null) return;

    if (action.screen == 'order_details') {
      final orderId = action.params['order_id'];

      if (orderId is int) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => OrderDetailsScreen(orderId: orderId),
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchDetails();
  }

  @override
  Widget build(BuildContext context) {
    final item = notification;

    return Scaffold(
      appBar: AppBar(title: const Text('Notification Details')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
          ? const Center(child: Text('Notification not found'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppColors.lightSurface,
                    borderRadius: BorderRadius.circular(22),
                    border: Border.all(color: AppColors.lightBorder),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        item.message,
                        style: const TextStyle(
                          color: AppColors.lightTextSecondary,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Type: ${item.type.toUpperCase()}',
                        style: const TextStyle(fontWeight: FontWeight.w800),
                      ),
                      if (item.createdAt != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          item.createdAt!.toLocal().toString(),
                          style: const TextStyle(color: AppColors.muted),
                        ),
                      ],
                    ],
                  ),
                ),
                if (item.action != null) ...[
                  const SizedBox(height: 20),
                  ElevatedButton.icon(
                    onPressed: () {
                      handleAction(item);
                    },
                    icon: const Icon(Icons.open_in_new_rounded),
                    label: Text(item.action!.label),
                  ),
                ],
              ],
            ),
    );
  }
}
