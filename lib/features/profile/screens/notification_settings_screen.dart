import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/notification_settings_model.dart';
import '../services/profile_api_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  final ProfileApiService service = ProfileApiService();

  bool isLoading = true;
  bool isSaving = false;

  NotificationSettingsModel? settings;

  Future<void> fetchSettings() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getNotificationSettings();

      if (!mounted) return;

      setState(() {
        settings = result;
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

  Future<void> saveSettings() async {
    final currentSettings = settings;

    if (currentSettings == null) return;

    setState(() {
      isSaving = true;
    });

    try {
      final response = await service.updateNotificationSettingsDemo(
        settings: currentSettings,
      );

      final updatedSettings = service.parseNotificationSettings(response);

      if (!mounted) return;

      setState(() {
        settings = updatedSettings ?? currentSettings;
      });

      AppToast.show(
        context,
        message:
            response['message'] ?? 'Notification settings updated successfully',
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
          isSaving = false;
        });
      }
    }
  }

  void updateSettings(NotificationSettingsModel value) {
    setState(() {
      settings = value;
    });
  }

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    final currentSettings = settings;

    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      bottomNavigationBar: currentSettings == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: ElevatedButton(
                  onPressed: isSaving ? null : saveSettings,
                  child: isSaving
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Text('Save Settings'),
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : currentSettings == null
          ? const Center(child: Text('Notification settings not found'))
          : ListView(
              padding: const EdgeInsets.all(20),
              children: [
                _SwitchTile(
                  title: 'Push Notification',
                  subtitle: 'Receive app push notifications',
                  value: currentSettings.pushNotification,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(pushNotification: value),
                    );
                  },
                ),
                _SwitchTile(
                  title: 'Email Notification',
                  subtitle: 'Receive updates by email',
                  value: currentSettings.emailNotification,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(emailNotification: value),
                    );
                  },
                ),
                _SwitchTile(
                  title: 'SMS Notification',
                  subtitle: 'Receive SMS alerts',
                  value: currentSettings.smsNotification,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(smsNotification: value),
                    );
                  },
                ),
                _SwitchTile(
                  title: 'Order Updates',
                  subtitle: 'Order status and delivery updates',
                  value: currentSettings.orderUpdates,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(orderUpdates: value),
                    );
                  },
                ),
                _SwitchTile(
                  title: 'Promotional Offers',
                  subtitle: 'Deals, discounts and campaigns',
                  value: currentSettings.promotionalOffers,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(promotionalOffers: value),
                    );
                  },
                ),
                _SwitchTile(
                  title: 'Wishlist Updates',
                  subtitle: 'Updates for favorite products',
                  value: currentSettings.wishlistUpdates,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(wishlistUpdates: value),
                    );
                  },
                ),
                _SwitchTile(
                  title: 'Support Updates',
                  subtitle: 'Support ticket and service updates',
                  value: currentSettings.supportUpdates,
                  onChanged: (value) {
                    updateSettings(
                      currentSettings.copyWith(supportUpdates: value),
                    );
                  },
                ),
                const SizedBox(height: 80),
              ],
            ),
    );
  }
}

class _SwitchTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchTile({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: SwitchListTile(
        value: value,
        onChanged: onChanged,
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
      ),
    );
  }
}
