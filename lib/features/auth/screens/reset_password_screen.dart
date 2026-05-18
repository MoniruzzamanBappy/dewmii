import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/auth_api_service.dart';
import '../widgets/auth_text_field.dart';
import 'login_screen.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;
  final String resetToken;

  const ResetPasswordScreen({
    super.key,
    required this.email,
    required this.resetToken,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final passwordController = TextEditingController(text: '123456');
  final confirmPasswordController = TextEditingController(text: '123456');

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> resetPassword() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final service = AuthApiService();

      final response = await service.resetPassword(
        email: widget.email,
        resetToken: widget.resetToken,
        password: passwordController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Password reset successful',
        type: ToastType.success,
      );

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
        (route) => false,
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
          isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Reset Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.lock_reset_rounded,
                size: 74,
                color: Color(0xFFD4698E),
              ),
              const SizedBox(height: 20),
              const Text(
                'Reset Password',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Set a new password for ${widget.email}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              AuthTextField(
                label: 'New Password',
                hintText: 'Enter new password',
                controller: passwordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Password is required';
                  }

                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Confirm Password',
                hintText: 'Confirm new password',
                controller: confirmPasswordController,
                obscureText: true,
                prefixIcon: const Icon(Icons.lock_outline_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Confirm password is required';
                  }

                  if (value != passwordController.text) {
                    return 'Passwords do not match';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : resetPassword,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Text('Reset Password'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
