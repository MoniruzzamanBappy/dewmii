import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/support_ticket_model.dart';

class SupportMessageBubble extends StatelessWidget {
  final SupportMessageModel message;

  const SupportMessageBubble({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final isCustomer = message.senderType == 'customer';

    return Align(
      alignment: isCustomer ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(14),
        constraints: const BoxConstraints(maxWidth: 310),
        decoration: BoxDecoration(
          color: isCustomer ? AppColors.primary : AppColors.lightSurface,
          borderRadius: BorderRadius.circular(18),
          border: isCustomer ? null : Border.all(color: AppColors.lightBorder),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.sender.name,
              style: TextStyle(
                color: isCustomer ? Colors.white : AppColors.lightTextPrimary,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              message.message,
              style: TextStyle(
                color: isCustomer ? Colors.white : AppColors.lightTextSecondary,
                height: 1.4,
              ),
            ),
            if (message.attachments.isNotEmpty) ...[
              const SizedBox(height: 10),
              SizedBox(
                height: 70,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: message.attachments.length,
                  itemBuilder: (context, index) {
                    return Container(
                      width: 70,
                      margin: const EdgeInsets.only(right: 8),
                      clipBehavior: Clip.antiAlias,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Image.network(
                        message.attachments[index],
                        fit: BoxFit.cover,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
