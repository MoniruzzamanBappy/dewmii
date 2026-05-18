import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/auth_api_service.dart';
import '../widgets/auth_text_field.dart';
import 'reset_password_screen.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;

  const OTPVerificationScreen({super.key, required this.email});

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final otpController = TextEditingController(text: '123456');

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> verifyOtp() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final service = AuthApiService();

      final response = await service.verifyOtp(
        email: widget.email,
        otp: otpController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'OTP verified successfully',
        type: ToastType.success,
      );

      final data = response['data'] as Map<String, dynamic>;

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ResetPasswordScreen(
            email: widget.email,
            resetToken: data['reset_token'],
          ),
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
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verify OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 40),
              const Icon(
                Icons.verified_user_rounded,
                size: 74,
                color: Color(0xFFD4698E),
              ),
              const SizedBox(height: 20),
              const Text(
                'OTP Verification',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                'Enter OTP sent to ${widget.email}',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              AuthTextField(
                label: 'OTP',
                hintText: 'Enter OTP',
                controller: otpController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.password_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'OTP is required';
                  }

                  if (value.length < 4) {
                    return 'Enter a valid OTP';
                  }

                  return null;
                },
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : verifyOtp,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Text('Verify OTP'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
