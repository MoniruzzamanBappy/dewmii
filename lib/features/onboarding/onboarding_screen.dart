import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../auth/screens/login_screen.dart';
import '../auth/screens/register_screen.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(gradient: AppColors.softGradient),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.85),
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    blurRadius: 28,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: const Icon(
                Icons.shopping_bag_outlined,
                size: 68,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(height: 32),
            const Text(
              'Welcome to Dewmii',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 34,
                fontWeight: FontWeight.bold,
                color: AppColors.lightTextPrimary,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              'Discover beautiful products, shop easily, and enjoy a modern e-commerce experience.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                height: 1.5,
                color: AppColors.lightTextSecondary,
              ),
            ),
            const SizedBox(height: 42),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Get Started'),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              height: 54,
              child: OutlinedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const RegisterScreen()),
                  );
                },
                child: const Text('Create Account'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
