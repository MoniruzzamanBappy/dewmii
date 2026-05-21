import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../services/auth_api_service.dart';
import '../widgets/auth_text_field.dart';
import 'login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with SingleTickerProviderStateMixin {
  static const String _logoPath = 'assets/images/logo.png';

  final usernameController = TextEditingController(text: 'rahim123');
  final emailController = TextEditingController(text: 'rahim@example.com');
  final passwordController = TextEditingController(text: '123456');
  final firstNameController = TextEditingController(text: 'Rahim');
  final lastNameController = TextEditingController(text: 'Uddin');
  final phoneController = TextEditingController(text: '+8801712345678');

  final formKey = GlobalKey<FormState>();

  late final AnimationController _controller;
  late final Animation<double> _fade;
  late final Animation<Offset> _slide;

  bool isLoading = false;
  bool obscurePassword = true;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 700),
    )..forward();

    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);

    _slide = Tween<Offset>(
      begin: const Offset(0, 0.04),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));
  }

  Future<void> register() async {
    if (!formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();

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

  void _goToLogin() {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const LoginScreen()),
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: SizedBox.expand(
        child: Container(
          decoration: BoxDecoration(
            gradient: isDark ? AppColors.darkGradient : AppColors.heroGradient,
          ),
          child: SafeArea(
            child: FadeTransition(
              opacity: _fade,
              child: SlideTransition(
                position: _slide,
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 500),
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color:
                              (isDark
                                      ? AppColors.darkSurface
                                      : AppColors.lightSurface)
                                  .withValues(alpha: 0.94),
                          borderRadius: BorderRadius.circular(32),
                          border: Border.all(
                            color: isDark
                                ? AppColors.darkBorder
                                : AppColors.lightBorder,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.12),
                              blurRadius: 32,
                              offset: const Offset(0, 18),
                            ),
                          ],
                        ),
                        child: Form(
                          key: formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: _goToLogin,
                                    icon: const Icon(Icons.arrow_back_rounded),
                                    tooltip: 'Back to login',
                                  ),
                                  const Spacer(),
                                ],
                              ),

                              const Center(child: _RegisterLogo(size: 92)),

                              const SizedBox(height: 18),

                              const Center(
                                child: Text(
                                  'Create Account',
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -0.5,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 6),

                              Center(
                                child: Text(
                                  'Join Dewmii and start shopping today',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              AuthTextField(
                                label: 'Username',
                                hintText: 'Enter username',
                                controller: usernameController,
                                prefixIcon: const Icon(Icons.person_rounded),
                                validator: (value) {
                                  final text = value?.trim() ?? '';

                                  if (text.isEmpty) {
                                    return 'Username is required';
                                  }

                                  if (text.length < 3) {
                                    return 'Username must be at least 3 characters';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              Row(
                                children: [
                                  Expanded(
                                    child: AuthTextField(
                                      label: 'First Name',
                                      hintText: 'First name',
                                      controller: firstNameController,
                                      prefixIcon: const Icon(
                                        Icons.badge_rounded,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Required';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: AuthTextField(
                                      label: 'Last Name',
                                      hintText: 'Last name',
                                      controller: lastNameController,
                                      prefixIcon: const Icon(
                                        Icons.badge_outlined,
                                      ),
                                      validator: (value) {
                                        if (value == null ||
                                            value.trim().isEmpty) {
                                          return 'Required';
                                        }

                                        return null;
                                      },
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 14),

                              AuthTextField(
                                label: 'Email',
                                hintText: 'Enter email',
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                prefixIcon: const Icon(Icons.email_rounded),
                                validator: (value) {
                                  final text = value?.trim() ?? '';

                                  if (text.isEmpty) {
                                    return 'Email is required';
                                  }

                                  if (!text.contains('@')) {
                                    return 'Enter a valid email';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              AuthTextField(
                                label: 'Phone Number',
                                hintText: 'Enter phone number',
                                controller: phoneController,
                                keyboardType: TextInputType.phone,
                                prefixIcon: const Icon(Icons.phone_rounded),
                                validator: (value) {
                                  final text = value?.trim() ?? '';

                                  if (text.isEmpty) {
                                    return 'Phone number is required';
                                  }

                                  if (text.length < 8) {
                                    return 'Enter a valid phone number';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 14),

                              AuthTextField(
                                label: 'Password',
                                hintText: 'Enter password',
                                controller: passwordController,
                                obscureText: obscurePassword,
                                prefixIcon: const Icon(Icons.lock_rounded),
                                suffixIcon: IconButton(
                                  tooltip: obscurePassword
                                      ? 'Show password'
                                      : 'Hide password',
                                  onPressed: () {
                                    setState(() {
                                      obscurePassword = !obscurePassword;
                                    });
                                  },
                                  icon: Icon(
                                    obscurePassword
                                        ? Icons.visibility_outlined
                                        : Icons.visibility_off_outlined,
                                  ),
                                ),
                                validator: (value) {
                                  final text = value ?? '';

                                  if (text.trim().isEmpty) {
                                    return 'Password is required';
                                  }

                                  if (text.length < 6) {
                                    return 'Password must be at least 6 characters';
                                  }

                                  return null;
                                },
                              ),

                              const SizedBox(height: 24),

                              SizedBox(
                                width: double.infinity,
                                height: 54,
                                child: FilledButton.icon(
                                  onPressed: isLoading ? null : register,
                                  icon: isLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person_add_alt_1_rounded,
                                        ),
                                  label: Text(
                                    isLoading
                                        ? 'Creating account...'
                                        : 'Create Account',
                                  ),
                                ),
                              ),

                              const SizedBox(height: 14),

                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: OutlinedButton(
                                  onPressed: _goToLogin,
                                  child: const Text(
                                    'Already have an account? Log In',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _RegisterLogo extends StatelessWidget {
  final double size;

  const _RegisterLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.96),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.16),
            blurRadius: 28,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Image.asset(
        _RegisterScreenState._logoPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(
            Icons.shopping_bag_rounded,
            color: AppColors.primary,
            size: 42,
          );
        },
      ),
    );
  }
}
