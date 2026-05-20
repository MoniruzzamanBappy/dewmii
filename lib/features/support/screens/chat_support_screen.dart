import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../models/support_ticket_model.dart';
import '../services/support_api_service.dart';
import '../widgets/support_message_bubble.dart';

class ChatSupportScreen extends StatefulWidget {
  final int ticketId;

  const ChatSupportScreen({super.key, required this.ticketId});

  @override
  State<ChatSupportScreen> createState() => _ChatSupportScreenState();
}

class _ChatSupportScreenState extends State<ChatSupportScreen> {
  final SupportApiService service = SupportApiService();
  final TextEditingController replyController = TextEditingController(
    text: 'Please check this issue as soon as possible.',
  );

  bool isLoading = true;
  bool isSending = false;
  SupportTicketDetailsModel? ticket;

  Future<void> fetchTicket() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getTicketDetails(widget.ticketId);
      if (!mounted) return;
      setState(() => ticket = result);
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

  Future<void> sendReply() async {
    final text = replyController.text.trim();
    if (text.isEmpty) {
      AppToast.show(context, message: 'Please write a message', type: ToastType.warning);
      return;
    }

    setState(() => isSending = true);

    try {
      final response = await service.replyTicket(ticketId: widget.ticketId, message: text);
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
      if (mounted) setState(() => isSending = false);
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

  String _pretty(String value) {
    if (value.isEmpty) return 'General';
    return value.replaceAll('_', ' ').split(' ').map((word) {
      if (word.isEmpty) return word;
      return '${word[0].toUpperCase()}${word.substring(1)}';
    }).join(' ');
  }

  @override
  Widget build(BuildContext context) {
    final item = ticket;
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(item?.ticketNumber ?? 'Chat Support')),
      bottomNavigationBar: item == null
          ? null
          : SafeArea(
              minimum: const EdgeInsets.fromLTRB(14, 8, 14, 14),
              child: Material(
                color: colors.surface,
                elevation: 8,
                shadowColor: colors.shadow.withValues(alpha: 0.16),
                borderRadius: BorderRadius.circular(24),
                clipBehavior: Clip.antiAlias,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(12, 8, 8, 8),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: replyController,
                          minLines: 1,
                          maxLines: 4,
                          keyboardType: TextInputType.multiline,
                          textInputAction: TextInputAction.newline,
                          decoration: const InputDecoration(
                            hintText: 'Write a reply...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      IconButton.filled(
                        onPressed: isSending ? null : sendReply,
                        icon: isSending
                            ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                            : const Icon(Icons.send_rounded),
                      ),
                    ],
                  ),
                ),
              ),
            ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : item == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.search_off_rounded, size: 72, color: colors.onSurfaceVariant),
                        const SizedBox(height: 12),
                        Text('Ticket not found', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  onRefresh: fetchTicket,
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                    children: [
                      Container(
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(26),
                          color: colors.primaryContainer.withValues(alpha: 0.6),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.subject, style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                _MetaChip(label: item.ticketNumber, icon: Icons.confirmation_number_rounded),
                                _MetaChip(label: _pretty(item.status), icon: Icons.timelapse_rounded),
                                _MetaChip(label: '${_pretty(item.priority)} priority', icon: Icons.flag_rounded),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      if (item.messages.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: colors.surfaceContainerHighest.withValues(alpha: 0.55),
                            borderRadius: BorderRadius.circular(24),
                          ),
                          child: const Text('No messages yet.', textAlign: TextAlign.center),
                        )
                      else
                        ...item.messages.map((message) => SupportMessageBubble(message: message)),
                    ],
                  ),
                ),
    );
  }
}

class _MetaChip extends StatelessWidget {
  final String label;
  final IconData icon;

  const _MetaChip({required this.label, required this.icon});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: colors.surface.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: colors.primary),
          const SizedBox(width: 5),
          Text(label, style: TextStyle(color: colors.primary, fontWeight: FontWeight.w800, fontSize: 12)),
        ],
      ),
    );
  }
}
