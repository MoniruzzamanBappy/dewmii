import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/order_tracking_model.dart';

class TrackingTimelineItem extends StatelessWidget {
  final OrderTrackingEventModel event;
  final bool isLast;

  const TrackingTimelineItem({
    super.key,
    required this.event,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color = event.isCompleted ? AppColors.success : theme.colorScheme.primary.withValues(alpha: 0.45);

    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0, end: 1),
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) => Opacity(
        opacity: value,
        child: Transform.translate(offset: Offset(12 * (1 - value), 0), child: child),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 260),
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: color.withValues(alpha: 0.22)),
                ),
                child: Icon(event.isCompleted ? Icons.check_rounded : Icons.radio_button_unchecked_rounded, size: 19, color: color),
              ),
              if (!isLast)
                Container(width: 2, height: 64, margin: const EdgeInsets.symmetric(vertical: 4), color: color.withValues(alpha: 0.22)),
            ],
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(event.title.isEmpty ? _label(event.status) : event.title, style: theme.textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 5),
                  Text(event.description.isEmpty ? 'Your order status has been updated.' : event.description, style: theme.textTheme.bodySmall?.copyWith(color: theme.textTheme.bodySmall?.color?.withValues(alpha: 0.64), height: 1.35)),
                  const SizedBox(height: 6),
                  Text(_formatDate(event.date), style: theme.textTheme.labelSmall?.copyWith(color: AppColors.muted, fontWeight: FontWeight.w700)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _label(String value) {
    if (value.trim().isEmpty) return 'Order update';
    return value.replaceAll('_', ' ').split(' ').map((e) => e.isEmpty ? e : '${e[0].toUpperCase()}${e.substring(1).toLowerCase()}').join(' ');
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'Date not available';
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    final local = date.toLocal();
    return '${months[local.month - 1]} ${local.day}, ${local.year}';
  }
}
