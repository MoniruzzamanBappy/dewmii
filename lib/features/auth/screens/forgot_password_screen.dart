import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/auth_api_service.dart';
import '../widgets/auth_text_field.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final emailController = TextEditingController(text: 'rahim@example.com');

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> sendOtp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final service = AuthApiService();

      final response = await service.forgotPassword(
        email: emailController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'OTP sent successfully',
        type: ToastType.success,
      );

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) =>
              OTPVerificationScreen(email: emailController.text.trim()),
        ),
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
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Forgot Password')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.mark_email_read_rounded,
                size: 74,
                color: Color(0xFFD4698E),
              ),
              const SizedBox(height: 20),
              const Text(
                'Forgot Password?',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Enter your email to receive password reset OTP.',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              AuthTextField(
                label: 'Email',
                hintText: 'Enter your email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: const Icon(Icons.email_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }

                  if (!value.contains('@')) {
                    return 'Enter a valid email';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : sendOtp,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Text('Send OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
