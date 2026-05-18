import 'package:dewmii/features/support/screens/chat_support_screen.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/support_ticket_model.dart';
import '../services/support_api_service.dart';
import '../widgets/support_ticket_card.dart';

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
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getTickets();

      if (!mounted) return;

      setState(() {
        tickets = result;
      });
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  Future<void> createDemoTicket() async {
    setState(() {
      isCreating = true;
    });

    try {
      final response = await service.createTicketDemo(
        subject: 'Order issue',
        message: 'I received the wrong product.',
        priority: 'medium',
        orderId: 1001,
      );

      final ticket = service.parseCreatedTicket(response);

      if (!mounted) return;

      setState(() {
        if (ticket != null) {
          tickets = [ticket, ...tickets];
        }
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
      if (mounted) {
        setState(() {
          isCreating = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTickets();
  }

  @override
  Widget build(BuildContext context) {
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
        icon: const Icon(Icons.add_rounded),
        label: const Text('Create Ticket'),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: fetchTickets,
              child: tickets.isEmpty
                  ? ListView(
                      padding: const EdgeInsets.all(24),
                      children: [
                        const SizedBox(height: 120),
                        Icon(
                          Icons.support_agent_rounded,
                          size: 94,
                          color: AppColors.primary.withValues(alpha: 0.65),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'No support tickets',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    )
                  : ListView(
                      padding: const EdgeInsets.all(20),
                      children: [
                        if (isCreating) ...[
                          const LinearProgressIndicator(),
                          const SizedBox(height: 14),
                        ],
                        ...tickets.map((ticket) {
                          return SupportTicketCard(
                            ticket: ticket,
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      ChatSupportScreen(ticketId: ticket.id),
                                ),
                              );
                            },
                          );
                        }),
                        const SizedBox(height: 90),
                      ],
                    ),
            ),
    );
  }
}
