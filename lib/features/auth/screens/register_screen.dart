import 'package:flutter/material.dart';

import '../../../shared/widgets/app_toast.dart';
import '../services/auth_api_service.dart';
import '../widgets/auth_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final usernameController = TextEditingController(text: 'rahim123');
  final emailController = TextEditingController(text: 'rahim@example.com');
  final passwordController = TextEditingController(text: '123456');
  final firstNameController = TextEditingController(text: 'Rahim');
  final lastNameController = TextEditingController(text: 'Uddin');
  final phoneController = TextEditingController(text: '+8801712345678');

  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final service = AuthApiService();

      final response = await service.register(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        phoneNumber: phoneController.text.trim(),
      );

      if (!mounted) return;

      AppToast.show(
        context,
        message: response.message,
        type: ToastType.success,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginScreen()),
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
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Register')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              const SizedBox(height: 12),
              const Text(
                'Create Account',
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 6),
              const Text(
                'Join Dewmii and start shopping today',
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              AuthTextField(
                label: 'Username',
                hintText: 'Enter username',
                controller: usernameController,
                prefixIcon: const Icon(Icons.person_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Username is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'First Name',
                hintText: 'Enter first name',
                controller: firstNameController,
                prefixIcon: const Icon(Icons.badge_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'First name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Last Name',
                hintText: 'Enter last name',
                controller: lastNameController,
                prefixIcon: const Icon(Icons.badge_outlined),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Last name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Email',
                hintText: 'Enter email',
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
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Phone Number',
                hintText: 'Enter phone number',
                controller: phoneController,
                keyboardType: TextInputType.phone,
                prefixIcon: const Icon(Icons.phone_rounded),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              AuthTextField(
                label: 'Password',
                hintText: 'Enter password',
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
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: isLoading ? null : register,
                  child: isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(strokeWidth: 2.4),
                        )
                      : const Text('Register'),
                ),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
