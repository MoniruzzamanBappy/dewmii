import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class CheckoutStepCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback onTap;

  const CheckoutStepCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: AppColors.softMuted,
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(subtitle),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      ),
    );
  }
}
