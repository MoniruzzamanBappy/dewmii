import 'package:dewmii/features/support/widgets/support_message_bubble.dart';
import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/support_ticket_model.dart';
import '../services/support_api_service.dart';

class ChatSupportScreen extends StatefulWidget {
  final int ticketId;

  const ChatSupportScreen({super.key, required this.ticketId});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final SupportApiService service = SupportApiService();
  final replyController = TextEditingController(
    text: 'Please check this issue as soon as possible.',
  );

  bool isLoading = true;
  bool isSending = false;

  SupportTicketDetailsModel? ticket;

  Future<void> fetchTicket() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getTicketDetails(widget.ticketId);

      if (!mounted) return;

      setState(() {
        ticket = result;
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

  Future<void> sendReply() async {
    if (replyController.text.trim().isEmpty) {
      AppToast.show(
        context,
        message: 'Please write a message',
        type: ToastType.warning,
      );
      return;
    }

    setState(() {
      isSending = true;
    });

    try {
      final response = await service.replyTicketDemo(
        ticketId: widget.ticketId,
        message: replyController.text.trim(),
      );

      final reply = service.parseReply(response);

      if (!mounted) return;

      setState(() {
        if (ticket != null && reply != null) {
          ticket = SupportTicketDetailsModel(
            id: ticket!.id,
            ticketNumber: ticket!.ticketNumber,
            subject: ticket!.subject,
            status: ticket!.status,
            priority: ticket!.priority,
            orderId: ticket!.orderId,
            messages: [...ticket!.messages, reply],
            createdAt: ticket!.createdAt,
            updatedAt: DateTime.now(),
          );
        }

        replyController.clear();
      });

      AppToast.show(
        context,
        message: response['message'] ?? 'Reply added successfully',
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
          isSending = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    fetchTicket();
  }

  @override
  void dispose() {
    replyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final item = ticket;

    return Scaffold(
      appBar: AppBar(title: Text(item?.ticketNumber ?? 'Chat Support')),
      bottomNavigationBar: item == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: replyController,
                        minLines: 1,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Write a reply...',
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    IconButton.filled(
                      onPressed: isSending ? null : sendReply,
                      icon: isSending
                          ? const SizedBox(
                              width: 18,
                              height: 18,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Icon(Icons.send_rounded),
                    ),
                  ],
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
          ? const Center(child: Text('Ticket not found'))
          : RefreshIndicator(
              onRefresh: fetchTicket,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Text(
                    item.subject,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${item.ticketNumber} • ${item.status} • ${item.priority}',
                  ),
                  const SizedBox(height: 20),
                  ...item.messages.map((message) {
                    return SupportMessageBubble(message: message);
                  }),
                  const SizedBox(height: 90),
                ],
              ),
            ),
    );
  }
}
