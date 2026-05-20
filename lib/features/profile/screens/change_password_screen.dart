import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../services/profile_api_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProfileApiService();
  final _currentController = TextEditingController();
  final _newController = TextEditingController();
  final _confirmController = TextEditingController();

  bool _isSaving = false;
  bool _hideCurrent = true;
  bool _hideNew = true;
  bool _hideConfirm = true;

  @override
  void dispose() {
    _currentController.dispose();
    _newController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSaving = true);
    try {
      final response = await _service.changePasswordDemo(
        currentPassword: _currentController.text.trim(),
        newPassword: _newController.text.trim(),
      );
      if (!mounted) return;
      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Password changed successfully',
        type: ToastType.success,
      );
      Navigator.pop(context);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Change Password')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _submit,
            icon: _isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.lock_reset_rounded),
            label: Text(_isSaving ? 'Updating...' : 'Update Password'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _HeroPanel(
            icon: Icons.shield_rounded,
            title: 'Secure your account',
            subtitle: 'Use a strong password with letters, numbers and symbols.',
            isDark: isDark,
          ),
          const SizedBox(height: 22),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _PasswordField(
                  controller: _currentController,
                  label: 'Current Password',
                  hidden: _hideCurrent,
                  onToggle: () => setState(() => _hideCurrent = !_hideCurrent),
                  validator: (value) => (value == null || value.isEmpty) ? 'Current password is required' : null,
                ),
                const SizedBox(height: 14),
                _PasswordField(
                  controller: _newController,
                  label: 'New Password',
                  hidden: _hideNew,
                  onToggle: () => setState(() => _hideNew = !_hideNew),
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'New password is required';
                    if (value.length < 6) return 'Password must be at least 6 characters';
                    return null;
                  },
                ),
                const SizedBox(height: 14),
                _PasswordField(
                  controller: _confirmController,
                  label: 'Confirm Password',
                  hidden: _hideConfirm,
                  onToggle: () => setState(() => _hideConfirm = !_hideConfirm),
                  validator: (value) => value != _newController.text ? 'Passwords do not match' : null,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PasswordField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final bool hidden;
  final VoidCallback onToggle;
  final String? Function(String?) validator;

  const _PasswordField({required this.controller, required this.label, required this.hidden, required this.onToggle, required this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: hidden,
      maxLines: 1,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: const Icon(Icons.lock_outline_rounded),
        suffixIcon: IconButton(
          onPressed: onToggle,
          icon: Icon(hidden ? Icons.visibility_off_rounded : Icons.visibility_rounded),
        ),
      ),
    );
  }
}

class _HeroPanel extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isDark;

  const _HeroPanel({required this.icon, required this.title, required this.subtitle, required this.isDark});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: isDark ? AppColors.darkHeroGradient : AppColors.heroGradient,
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          CircleAvatar(radius: 28, backgroundColor: Colors.white.withValues(alpha: 0.22), child: Icon(icon, color: Colors.white, size: 30)),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white)),
                const SizedBox(height: 6),
                Text(subtitle, style: TextStyle(color: Colors.white.withValues(alpha: 0.9), height: 1.35)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
