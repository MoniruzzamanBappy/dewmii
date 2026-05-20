import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/notification_settings_model.dart';
import '../services/profile_api_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  final ProfileApiService service = ProfileApiService();
  bool isLoading = true;
  bool isSaving = false;
  NotificationSettingsModel? settings;

  Future<void> fetchSettings() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getNotificationSettings();
      if (!mounted) return;
      setState(() => settings = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> saveSettings() async {
    final current = settings;
    if (current == null) return;
    setState(() => isSaving = true);
    try {
      final response = await service.updateNotificationSettingsDemo(settings: current);
      final updated = service.parseNotificationSettings(response);
      if (!mounted) return;
      setState(() => settings = updated ?? current);
      AppToast.show(context, message: response['message']?.toString() ?? 'Notification settings updated successfully', type: ToastType.success);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isSaving = false);
    }
  }

  void updateSettings(NotificationSettingsModel value) => setState(() => settings = value);

  @override
  void initState() {
    super.initState();
    fetchSettings();
  }

  @override
  Widget build(BuildContext context) {
    final current = settings;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      bottomNavigationBar: current == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: FilledButton.icon(
                  onPressed: isSaving ? null : saveSettings,
                  icon: isSaving
                      ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                      : const Icon(Icons.save_rounded),
                  label: Text(isSaving ? 'Saving...' : 'Save Settings'),
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : current == null
              ? _EmptyState(onRetry: fetchSettings)
              : ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(radius: 28, backgroundColor: Colors.white.withValues(alpha: 0.22), child: const Icon(Icons.notifications_active_rounded, color: Colors.white)),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Stay in control', style: TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                                const SizedBox(height: 5),
                                Text('Choose how Dewmii sends updates to you.', style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    _SwitchCard(title: 'Push Notification', subtitle: 'Receive app push notifications', icon: Icons.phone_android_rounded, value: current.pushNotification, onChanged: (value) => updateSettings(current.copyWith(pushNotification: value))),
                    _SwitchCard(title: 'Email Notification', subtitle: 'Receive updates by email', icon: Icons.email_outlined, value: current.emailNotification, onChanged: (value) => updateSettings(current.copyWith(emailNotification: value))),
                    _SwitchCard(title: 'SMS Notification', subtitle: 'Receive SMS alerts', icon: Icons.sms_outlined, value: current.smsNotification, onChanged: (value) => updateSettings(current.copyWith(smsNotification: value))),
                    _SwitchCard(title: 'Order Updates', subtitle: 'Order status and delivery updates', icon: Icons.local_shipping_outlined, value: current.orderUpdates, onChanged: (value) => updateSettings(current.copyWith(orderUpdates: value))),
                    _SwitchCard(title: 'Promotional Offers', subtitle: 'Deals, discounts and campaigns', icon: Icons.local_offer_outlined, value: current.promotionalOffers, onChanged: (value) => updateSettings(current.copyWith(promotionalOffers: value))),
                    _SwitchCard(title: 'Wishlist Updates', subtitle: 'Favorite product price and stock updates', icon: Icons.favorite_outline_rounded, value: current.wishlistUpdates, onChanged: (value) => updateSettings(current.copyWith(wishlistUpdates: value))),
                    _SwitchCard(title: 'Support Updates', subtitle: 'Support ticket and service updates', icon: Icons.support_agent_rounded, value: current.supportUpdates, onChanged: (value) => updateSettings(current.copyWith(supportUpdates: value))),
                    const SizedBox(height: 90),
                  ],
                ),
    );
  }
}

class _SwitchCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _SwitchCard({required this.title, required this.subtitle, required this.icon, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: () => onChanged(!value),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(backgroundColor: AppColors.primary.withValues(alpha: 0.12), child: Icon(icon, color: AppColors.primary)),
                const SizedBox(width: 14),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: const TextStyle(fontWeight: FontWeight.w900)), const SizedBox(height: 3), Text(subtitle, style: TextStyle(color: isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary))])),
                Switch.adaptive(value: value, onChanged: onChanged),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyState({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.notifications_off_outlined, size: 64, color: AppColors.primary),
            const SizedBox(height: 12),
            const Text('Notification settings not found', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18)),
            const SizedBox(height: 12),
            OutlinedButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
