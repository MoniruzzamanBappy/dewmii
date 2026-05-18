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
  final messageController = TextEditingController(
    text: 'I need help with my order.',
  );

  bool isLoading = false;

  Future<void> submitContact() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await service.submitContactDemo(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        phone: phoneController.text.trim(),
        subject: subjectController.text.trim(),
        message: messageController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message:
            response['message'] ?? 'Contact message submitted successfully',
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
      if (mounted) {
        setState(() {
          isLoading = false;
        });
      }
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
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return '$label is required';
          }

          if (label == 'Email' && !value.contains('@')) {
            return 'Enter a valid email';
          }

          return null;
        },
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field(label: 'Name', controller: nameController),
            _field(
              label: 'Email',
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            _field(
              label: 'Phone',
              controller: phoneController,
              keyboardType: TextInputType.phone,
            ),
            _field(label: 'Subject', controller: subjectController),
            _field(
              label: 'Message',
              controller: messageController,
              maxLines: 5,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : submitContact,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Submit Message'),
            ),
          ],
        ),
      ),
    );
  }
}
