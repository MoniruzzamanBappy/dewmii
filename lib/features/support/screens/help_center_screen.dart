import 'package:flutter/material.dart';

import 'chat_support_screen.dart';
import 'contact_us_screen.dart';
import 'faq_screen.dart';
import 'support_ticket_screen.dart';

class HelpCenterScreen extends StatelessWidget {
  const HelpCenterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Help Center')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        children: [
          _HeroCard(colors: colors, theme: theme),
          const SizedBox(height: 22),
          Text(
            'Support options',
            style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 12),
          _HelpTile(
            index: 0,
            icon: Icons.quiz_rounded,
            title: 'FAQs',
            subtitle: 'Browse common questions and quick answers',
            color: colors.primary,
            onTap: () => _push(context, const FAQScreen()),
          ),
          _HelpTile(
            index: 1,
            icon: Icons.mail_rounded,
            title: 'Contact Us',
            subtitle: 'Send a message to Dewmii support',
            color: Colors.teal,
            onTap: () => _push(context, const ContactUsScreen()),
          ),
          _HelpTile(
            index: 2,
            icon: Icons.confirmation_number_rounded,
            title: 'Support Tickets',
            subtitle: 'Create tickets and track support progress',
            color: Colors.orange,
            onTap: () => _push(context, const SupportTicketScreen()),
          ),
          _HelpTile(
            index: 3,
            icon: Icons.chat_rounded,
            title: 'Chat Support',
            subtitle: 'Open your latest demo support conversation',
            color: Colors.purple,
            onTap: () => _push(context, const ChatSupportScreen(ticketId: 1)),
          ),
        ],
      ),
    );
  }

  void _push(BuildContext context, Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (_, animation, __) => page,
        transitionsBuilder: (_, animation, __, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeOutCubic);
          return FadeTransition(
            opacity: curved,
            child: SlideTransition(
              position: Tween<Offset>(begin: const Offset(0.06, 0.02), end: Offset.zero).animate(curved),
              child: child,
            ),
          );
        },
      ),
    );
  }
}

class _HeroCard extends StatelessWidget {
  final ColorScheme colors;
  final ThemeData theme;

  const _HeroCard({required this.colors, required this.theme});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      duration: const Duration(milliseconds: 550),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 24 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              colors.primaryContainer,
              colors.primary.withValues(alpha: 0.14),
              colors.surface,
            ],
          ),
          border: Border.all(color: colors.primary.withValues(alpha: 0.16)),
          boxShadow: [
            BoxShadow(
              color: colors.primary.withValues(alpha: 0.13),
              blurRadius: 26,
              offset: const Offset(0, 14),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: colors.primary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(22),
              ),
              child: Icon(Icons.support_agent_rounded, size: 36, color: colors.primary),
            ),
            const SizedBox(height: 18),
            Text(
              'How can we help?',
              style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            Text(
              'Find answers, contact support, or continue a support ticket from one place.',
              style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant, height: 1.45),
            ),
          ],
        ),
      ),
    );
  }
}

class _HelpTile extends StatelessWidget {
  final int index;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  const _HelpTile({
    required this.index,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return TweenAnimationBuilder<double>(
      duration: Duration(milliseconds: 360 + (index * 70)),
      tween: Tween(begin: 0, end: 1),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 18 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 13),
        child: Material(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: colors.outlineVariant.withValues(alpha: 0.55)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: Icon(icon, color: color),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(subtitle, style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                      ],
                    ),
                  ),
                  Icon(Icons.arrow_forward_ios_rounded, size: 16, color: colors.onSurfaceVariant),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
