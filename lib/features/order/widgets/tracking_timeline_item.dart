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
    final color = event.isCompleted ? AppColors.success : AppColors.muted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            CircleAvatar(
              radius: 15,
              backgroundColor: color.withValues(alpha: 0.15),
              child: Icon(
                event.isCompleted ? Icons.check_rounded : Icons.circle_outlined,
                size: 18,
                color: color,
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 58,
                color: color.withValues(alpha: 0.25),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(bottom: 26),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  event.title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  event.description,
                  style: const TextStyle(color: AppColors.lightTextSecondary),
                ),
                if (event.date != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    event.date!.toLocal().toString(),
                    style: const TextStyle(
                      color: AppColors.muted,
                      fontSize: 12,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ],
    );
  }
}
