import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/support_api_service.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final SupportApiService service = SupportApiService();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController(text: 'Rahim Uddin');
  final emailController = TextEditingController(text: 'rahim@example.com');
  final phoneController = TextEditingController(text: '+8801712345678');
  final subjectController = TextEditingController(text: 'Order issue');
  final messageController = TextEditingController(text: 'I need help with my order.');

  bool isLoading = false;

  Future<void> submitContact() async {
    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() => isLoading = true);

    try {
      final response = await service.submitContact(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
      );

      if (!mounted) return;
      AppToast.show(
        context,
        message: response['message'] ?? 'Contact message submitted successfully',
        type: ToastType.success,
      );
      Navigator.pop(context);
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

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    subjectController.dispose();
    messageController.dispose();
    super.dispose();
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        keyboardType: maxLines > 1 ? TextInputType.multiline : keyboardType,
        minLines: maxLines > 1 ? 3 : 1,
        maxLines: maxLines,
        textInputAction: maxLines > 1 ? TextInputAction.done : TextInputAction.next,
        validator: (value) {
          final text = value?.trim() ?? '';
          if (text.isEmpty) return '$label is required';
          if (label == 'Email' && !RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(text)) {
            return 'Enter a valid email';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          alignLabelWithHint: maxLines > 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: FilledButton.icon(
          onPressed: isLoading ? null : submitContact,
          icon: isLoading
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2.2),
                )
              : const Icon(Icons.send_rounded),
          label: Text(isLoading ? 'Sending...' : 'Submit Message'),
        ),
      ),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(28),
                gradient: LinearGradient(
                  colors: [
                    colors.primaryContainer,
                    colors.surfaceContainerHighest.withValues(alpha: 0.45),
                  ],
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 58,
                    height: 58,
                    decoration: BoxDecoration(
                      color: colors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Icon(Icons.mark_email_read_rounded, color: colors.primary, size: 30),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Write to support', style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
                        const SizedBox(height: 4),
                        Text(
                          'Tell us what happened. We will get back to you soon.',
                          style: theme.textTheme.bodySmall?.copyWith(color: colors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 22),
            _field(label: 'Name', controller: nameController, icon: Icons.person_rounded),
            _field(
              label: 'Email',
              controller: emailController,
              icon: Icons.email_rounded,
              keyboardType: TextInputType.emailAddress,
            ),
            _field(
              label: 'Phone',
              controller: phoneController,
              icon: Icons.phone_rounded,
              keyboardType: TextInputType.phone,
            ),
            _field(label: 'Subject', controller: subjectController, icon: Icons.subject_rounded),
            _field(
              label: 'Message',
              controller: messageController,
              icon: Icons.notes_rounded,
              maxLines: 5,
            ),
          ],
        ),
      ),
    );
  }
}
