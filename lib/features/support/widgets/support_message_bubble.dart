import 'package:flutter/material.dart';

import '../models/support_ticket_model.dart';

class SupportMessageBubble extends StatelessWidget {
  final SupportMessageModel message;

  const SupportMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;
    final isCustomer = message.senderType.toLowerCase() == 'customer';
    final bubbleColor = isCustomer ? colors.primary : colors.surfaceContainerHighest;
    final textColor = isCustomer ? colors.onPrimary : colors.onSurface;

    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 300),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(isCustomer ? 14 * (1 - value) : -14 * (1 - value), 0),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Align(
        alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14),
          padding: const EdgeInsets.all(14),
          constraints: BoxConstraints(maxWidth: MediaQuery.sizeOf(context).width * 0.78),
          decoration: BoxDecoration(
            color: bubbleColor,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(22),
              topRight: const Radius.circular(22),
              bottomLeft: Radius.circular(isCustomer ? 22 : 6),
              bottomRight: Radius.circular(isCustomer ? 6 : 22),
            ),
            border: isCustomer ? null : Border.all(color: colors.outlineVariant.withValues(alpha: 0.55)),
            boxShadow: [
              BoxShadow(
                color: colors.shadow.withValues(alpha: 0.07),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: isCustomer
                        ? colors.onPrimary.withValues(alpha: 0.18)
                        : colors.primary.withValues(alpha: 0.12),
                    child: Text(
                      message.sender.name.isEmpty ? '?' : message.sender.name.characters.first.toUpperCase(),
                      style: TextStyle(
                        color: isCustomer ? colors.onPrimary : colors.primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    message.sender.name,
                    style: theme.textTheme.labelMedium?.copyWith(
                      color: textColor,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                message.message,
                style: theme.textTheme.bodyMedium?.copyWith(color: textColor, height: 1.45),
              ),
              if (message.attachments.isNotEmpty) ...[
                const SizedBox(height: 12),
                SizedBox(
                  height: 74,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: message.attachments.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      return ClipRRect(
                        borderRadius: BorderRadius.circular(14),
                        child: Image.network(
                          message.attachments[index],
                          width: 74,
                          height: 74,
                          fit: BoxFit.cover,
                          errorBuilder: (_, _, _) => Container(
                            width: 74,
                            height: 74,
                            color: colors.surfaceContainerHighest,
                            child: Icon(Icons.broken_image_rounded, color: colors.onSurfaceVariant),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
