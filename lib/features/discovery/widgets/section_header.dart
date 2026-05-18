import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final String? actionText;
  final VoidCallback? onActionTap;

  const SectionHeader({
    super.key,
    required this.title,
    this.actionText,
    this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w800,
            color: AppColors.lightTextPrimary,
          ),
        ),
        const Spacer(),
        if (actionText != null)
          TextButton(onPressed: onActionTap, child: Text(actionText!)),
      ],
    );
  }
}
