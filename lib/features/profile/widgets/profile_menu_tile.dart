import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class ProfileMenuTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;

  const ProfileMenuTile({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.lightSurface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.lightBorder),
      ),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(12),
        leading: CircleAvatar(
          backgroundColor: (iconColor ?? AppColors.primary).withValues(
            alpha: 0.12,
          ),
          child: Icon(icon, color: iconColor ?? AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      ),
    );
  }
}
