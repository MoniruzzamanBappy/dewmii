import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import 'chat_support_screen.dart';
import 'contact_us_screen.dart';
import 'faq_screen.dart';
import 'support_ticket_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(24),
            ),
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.support_agent_rounded,
                  size: 58,
                  color: AppColors.primary,
                ),
                SizedBox(height: 16),
                Text(
                  'How can we help?',
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900),
                ),
                SizedBox(height: 8),
                Text(
                  'Find answers, contact support, or track your support tickets.',
                  style: TextStyle(
                    color: AppColors.lightTextSecondary,
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 22),
          _HelpTile(
            icon: Icons.quiz_rounded,
            title: 'FAQs',
            subtitle: 'Common questions and answers',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const FAQScreen()),
              );
            },
          ),
          _HelpTile(
            icon: Icons.mail_rounded,
            title: 'Contact Us',
            subtitle: 'Send a message to Dewmii support',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ContactUsScreen()),
              );
            },
          ),
          _HelpTile(
            icon: Icons.confirmation_number_rounded,
            title: 'Support Tickets',
            subtitle: 'View and create support tickets',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SupportTicketScreen()),
              );
            },
          ),
          _HelpTile(
            icon: Icons.chat_rounded,
            title: 'Chat Support',
            subtitle: 'Open existing support chat',
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const ChatSupportScreen(ticketId: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _HelpTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        onTap: onTap,
        contentPadding: const EdgeInsets.all(14),
        leading: CircleAvatar(
          backgroundColor: AppColors.primary.withValues(alpha: 0.12),
          child: Icon(icon, color: AppColors.primary),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w900)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios_rounded, size: 18),
      ),
    );
  }
}
