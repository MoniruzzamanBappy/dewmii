import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/support_ticket_model.dart';
import '../services/support_api_service.dart';
import '../widgets/support_ticket_card.dart';
import 'chat_support_screen.dart';

class SupportTicketScreen extends StatefulWidget {
  const SupportTicketScreen({super.key});

  @override
  State<SupportTicketScreen> createState() => _SupportTicketScreenState();
}

class _SupportTicketScreenState extends State<SupportTicketScreen> {
  final SupportApiService service = SupportApiService();

  bool isLoading = true;
  bool isCreating = false;
  List<SupportTicketModel> tickets = [];

  Future<void> fetchTickets() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getTickets();
      if (!mounted) return;
      setState(() => tickets = result);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> createDemoTicket() async {
    setState(() => isCreating = true);

    try {
      final response = await service.createTicket(
        subject: 'Order issue',
        message: 'I received the wrong product.',
        priority: 'medium',
        orderId: 1001,
      );
      final ticket = service.parseCreatedTicket(response);

      if (!mounted) return;
      setState(() {
        if (ticket != null) tickets = [ticket, ...tickets];
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Support ticket created successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isCreating = false);
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Support Tickets'),
        actions: [
          IconButton(
            onPressed: isCreating ? null : createDemoTicket,
            icon: const Icon(Icons.add_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: isCreating ? null : createDemoTicket,
        icon: isCreating
            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
            : const Icon(Icons.add_rounded),
        label: Text(isCreating ? 'Creating...' : 'Create Ticket'),
      ),
      body: isLoading
          ? const _TicketSkeleton()
          : RefreshIndicator(
              onRefresh: fetchTickets,
              child: tickets.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 90),
                        Container(
                          width: 110,
                          height: 110,
                          decoration: BoxDecoration(
                            color: colors.primary.withValues(alpha: 0.10),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.support_agent_rounded, size: 58, color: colors.primary),
                        ),
                        const SizedBox(height: 18),
                        Text(
                          'No support tickets',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Create a ticket when you need help with an order, return, payment, or account issue.',
                          textAlign: TextAlign.center,
                          style: theme.textTheme.bodyMedium?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.fromLTRB(20, 12, 20, 100),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: colors.primaryContainer.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(26),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.confirmation_number_rounded, color: colors.primary, size: 34),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('${tickets.length} active tickets', style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900)),
                                    Text('Tap any ticket to continue the conversation.', style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (isCreating) ...[
                          const SizedBox(height: 14),
                          const LinearProgressIndicator(),
                        ],
                        const SizedBox(height: 18),
                        ...tickets.map(
                          (ticket) => SupportTicketCard(
                            ticket: ticket,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (_) => ChatSupportScreen(ticketId: ticket.id)),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
            ),
    );
  }
}

class _TicketSkeleton extends StatelessWidget {
  const _TicketSkeleton();

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: 6,
      separatorBuilder: (_, _) => const SizedBox(height: 14),
      itemBuilder: (context, index) {
        return Container(
          height: index == 0 ? 94 : 96,
          decoration: BoxDecoration(
            color: colors.surfaceContainerHighest.withValues(alpha: 0.65),
            borderRadius: BorderRadius.circular(24),
          ),
        );
      },
    );
  }
}
