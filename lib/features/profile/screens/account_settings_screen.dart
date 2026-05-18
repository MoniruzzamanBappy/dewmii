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
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete Account?'),
          content: const Text(
            'This demo action will mark your account as deleted. Are you sure?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (shouldDelete != true) return;

    setState(() {
      isDeleting = true;
    });

    try {
      final response = await service.deleteAccountDemo();

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Account deleted successfully',
        type: ToastType.success,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
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
          isDeleting = false;
        });
      }
    }
  }

  void deactivateDemo() {
    AppToast.show(
      context,
      message: 'Deactivate account demo action clicked',
      type: ToastType.info,
    );
  }

  void logoutDemo() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Account Settings')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const Text(
            'Account Management',
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          const Text(
            'Manage your account access, logout, deactivate or delete account.',
            style: TextStyle(color: AppColors.lightTextSecondary, height: 1.4),
          ),
          const SizedBox(height: 22),
          Card(
            child: ListTile(
              leading: const Icon(Icons.logout_rounded),
              title: const Text(
                'Logout',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text('Sign out from this device'),
              onTap: logoutDemo,
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.pause_circle_rounded),
              title: const Text(
                'Deactivate Account',
                style: TextStyle(fontWeight: FontWeight.w900),
              ),
              subtitle: const Text('Temporarily deactivate your account'),
              onTap: deactivateDemo,
            ),
          ),
          Card(
            child: ListTile(
              enabled: !isDeleting,
              leading: const Icon(
                Icons.delete_forever_rounded,
                color: AppColors.error,
              ),
              title: const Text(
                'Delete Account',
                style: TextStyle(
                  fontWeight: FontWeight.w900,
                  color: AppColors.error,
                ),
              ),
              subtitle: const Text('Permanently delete your account'),
              trailing: isDeleting
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : null,
              onTap: isDeleting ? null : deleteAccount,
            ),
          ),
        ],
      ),
    );
  }
}
