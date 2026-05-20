import 'package:dewmii/shared/widgets/navigation/main_navigation_shell.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class OrderFailedScreen extends StatelessWidget {
  final String message;

  const OrderFailedScreen({
    super.key,
    this.message = 'Something went wrong while placing your order.',
  });

  @override
  Widget build(BuildContext context) {
    final dark = Theme.of(context).brightness == Brightness.dark;
    final secondary = dark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 70),
            Container(
              width: 118,
              height: 118,
              margin: const EdgeInsets.symmetric(horizontal: 100),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.error_rounded, color: AppColors.error, size: 78),
            ),
            const SizedBox(height: 28),
            const Text(
              'Order Failed',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(color: secondary, height: 1.4),
            ),
            const SizedBox(height: 28),
            FilledButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.refresh_rounded),
              label: const Text('Try Again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => const MainNavigationShell()),
                  (route) => false,
                );
              },
              icon: const Icon(Icons.home_rounded),
              label: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
