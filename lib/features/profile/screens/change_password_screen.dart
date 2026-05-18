import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/profile_api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final ProfileApiService service = ProfileApiService();
  final formKey = GlobalKey<FormState>();

  final currentPasswordController = TextEditingController(text: '123456');
  final newPasswordController = TextEditingController(text: '1234567');
  final confirmPasswordController = TextEditingController(text: '1234567');

  bool isLoading = false;

  Future<void> changePassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await service.changePasswordDemo(
        currentPassword: currentPasswordController.text.trim(),
        newPassword: newPasswordController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Password changed successfully',
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
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  Widget _passwordField({
    required String label,
    required TextEditingController controller,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
        obscureText: true,
        validator: validator,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: const Icon(Icons.lock_rounded),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _passwordField(
              label: 'Current Password',
              controller: currentPasswordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Current password is required';
                }

                return null;
              },
            ),
            _passwordField(
              label: 'New Password',
              controller: newPasswordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'New password is required';
                }

                if (value.length < 6) {
                  return 'Password must be at least 6 characters';
                }

                return null;
              },
            ),
            _passwordField(
              label: 'Confirm Password',
              controller: confirmPasswordController,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'Confirm password is required';
                }

                if (value != newPasswordController.text) {
                  return 'Passwords do not match';
                }

                return null;
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : changePassword,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Change Password'),
            ),
          ],
        ),
      ),
    );
  }
}
