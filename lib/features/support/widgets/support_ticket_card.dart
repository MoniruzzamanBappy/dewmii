import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../models/support_ticket_model.dart';

class SupportTicketCard extends StatelessWidget {
  final SupportTicketModel ticket;
  final VoidCallback onTap;

  const SupportTicketCard({
    super.key,
    required this.ticket,
    required this.onTap,
  });

  Color get statusColor {
    switch (ticket.status) {
      case 'open':
        return AppColors.success;
      case 'in_progress':
        return AppColors.warning;
      case 'closed':
        return AppColors.muted;
      default:
        return AppColors.primary;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: statusColor.withValues(alpha: 0.12),
          child: Icon(Icons.support_agent_rounded, color: statusColor),
        ),
        title: Text(
          ticket.subject,
          style: const TextStyle(fontWeight: FontWeight.w900),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            '${ticket.ticketNumber} • ${ticket.priority}\n${ticket.lastMessage}',
          ),
        ),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      ),
    );
  }
}
