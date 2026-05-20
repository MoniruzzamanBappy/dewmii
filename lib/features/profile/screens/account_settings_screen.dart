import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../auth/screens/login_screen.dart';
import '../services/profile_api_service.dart';

class AccountSettingsScreen extends StatefulWidget {
  const AccountSettingsScreen({super.key});

  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  final ProfileApiService service = ProfileApiService();
  bool isDeleting = false;

  Future<void> deleteAccount() async {
    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const CircleAvatar(
              radius: 26,
              backgroundColor: AppColors.errorSurface,
              child: Icon(Icons.delete_forever_rounded, color: AppColors.error),
            ),
            const SizedBox(height: 16),
            const Text('Delete account?', style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900)),
            const SizedBox(height: 8),
            const Text('This demo action will mark your account as deleted and return you to login.'),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () => Navigator.pop(context, false), child: const Text('Cancel'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: () => Navigator.pop(context, true), child: const Text('Delete'))),
              ],
            ),
          ],
        ),
      ),
    );

    if (shouldDelete != true) return;
    setState(() => isDeleting = true);
    try {
      final response = await service.deleteAccountDemo();
      if (!mounted) return;
      AppToast.show(context, message: response['message']?.toString() ?? 'Account deleted successfully', type: ToastType.success);
      Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isDeleting = false);
    }
  }

  void deactivateDemo() {
    AppToast.show(context, message: 'Deactivate account demo action clicked', type: ToastType.info);
  }

  void logoutDemo() {
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (_) => const LoginScreen()), (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.darkHeroGradient : AppColors.sageGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.manage_accounts_rounded, size: 38, color: AppColors.primary),
                SizedBox(height: 14),
                Text('Account Management', style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900)),
                SizedBox(height: 6),
                Text('Manage access, logout, deactivate, or delete your account safely.'),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _ActionCard(icon: Icons.logout_rounded, title: 'Logout', subtitle: 'Sign out from this device', onTap: logoutDemo),
          const SizedBox(height: 12),
          _ActionCard(icon: Icons.pause_circle_rounded, title: 'Deactivate Account', subtitle: 'Temporarily deactivate your account', onTap: deactivateDemo, color: AppColors.warning),
          const SizedBox(height: 12),
          _ActionCard(
            icon: Icons.delete_forever_rounded,
            title: 'Delete Account',
            subtitle: 'Permanently delete your account',
            onTap: isDeleting ? null : deleteAccount,
            color: AppColors.error,
            trailing: isDeleting ? const SizedBox(width: 22, height: 22, child: CircularProgressIndicator(strokeWidth: 2.4)) : null,
          ),
        ],
      ),
    );
  }
}

class _ActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;
  final Color color;
  final Widget? trailing;

  const _ActionCard({required this.icon, required this.title, required this.subtitle, required this.onTap, this.color = AppColors.primary, this.trailing});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
      borderRadius: BorderRadius.circular(22),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              CircleAvatar(backgroundColor: color.withValues(alpha: 0.12), child: Icon(icon, color: color)),
              const SizedBox(width: 14),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text(title, style: TextStyle(fontWeight: FontWeight.w900, color: color == AppColors.error ? color : null)), const SizedBox(height: 3), Text(subtitle)])),
              trailing ?? Icon(Icons.arrow_forward_ios_rounded, size: 16, color: isDark ? AppColors.darkTextTertiary : AppColors.lightTextTertiary),
            ],
          ),
        ),
      ),
    );
  }
}
