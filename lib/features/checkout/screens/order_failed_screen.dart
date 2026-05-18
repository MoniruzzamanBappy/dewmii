import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class OrderFailedScreen extends StatelessWidget {
  final String message;

  const OrderFailedScreen({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const SizedBox(height: 90),
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.error_rounded,
                color: AppColors.error,
                size: 72,
              ),
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
              style: const TextStyle(
                color: AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Try Again'),
            ),
            const SizedBox(height: 12),
            OutlinedButton(
              onPressed: () {
                Navigator.popUntil(context, (route) => route.isFirst);
              },
              child: const Text('Back to Home'),
            ),
          ],
        ),
      ),
    );
  }
}
