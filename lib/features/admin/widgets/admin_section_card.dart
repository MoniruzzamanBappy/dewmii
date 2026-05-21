import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class AdminSectionCard extends StatelessWidget {
  final String title;
  final Widget child;
  final VoidCallback? onViewAll;
  final IconData? icon;

  const AdminSectionCard({
    super.key,
    required this.title,
    required this.child,
    this.onViewAll,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: isDark ? AppColors.darkBorder : AppColors.lightBorder),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(9),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: AppColors.primary, size: 19),
                ),
                const SizedBox(width: 10),
              ],
              Expanded(
                child: Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
              ),
              if (onViewAll != null)
                TextButton(onPressed: onViewAll, child: const Text('View')),
            ],
          ),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }
}
