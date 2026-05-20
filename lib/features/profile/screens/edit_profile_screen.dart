import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../models/profile_model.dart';
import '../services/profile_api_service.dart';

class EditProfileScreen extends StatefulWidget {
  final ProfileModel profile;

  const EditProfileScreen({super.key, required this.profile});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _service = ProfileApiService();
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;
  late final TextEditingController _displayNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _usernameController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: widget.profile.firstName);
    _lastNameController = TextEditingController(text: widget.profile.lastName);
    _displayNameController = TextEditingController(text: widget.profile.displayName);
    _phoneController = TextEditingController(text: widget.profile.phoneNumber);
    _usernameController = TextEditingController(text: widget.profile.username);
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _displayNameController.dispose();
    _phoneController.dispose();
    _usernameController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    final updated = widget.profile.copyWith(
      firstName: _firstNameController.text.trim(),
      lastName: _lastNameController.text.trim(),
      displayName: _displayNameController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      username: _usernameController.text.trim(),
    );

    setState(() => _isSaving = true);
    try {
      final response = await _service.updateProfileDemo(profile: updated);
      final parsed = _service.parseProfile(response) ?? updated;
      if (!mounted) return;
      AppToast.show(
        context,
        message: response['message']?.toString() ?? 'Profile updated successfully',
        type: ToastType.success,
      );
      Navigator.pop(context, parsed);
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
      appBar: AppBar(title: const Text('Edit Profile')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FilledButton.icon(
            onPressed: _isSaving ? null : _save,
            icon: _isSaving
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.check_circle_rounded),
            label: Text(_isSaving ? 'Saving...' : 'Save Changes'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(22),
            decoration: BoxDecoration(
              gradient: isDark ? AppColors.darkHeroGradient : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white.withValues(alpha: 0.22),
                  backgroundImage: widget.profile.avatarUrl == null ? null : NetworkImage(widget.profile.avatarUrl!),
                  child: widget.profile.avatarUrl == null
                      ? Text(widget.profile.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Update your details', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20)),
                      const SizedBox(height: 5),
                      Text(widget.profile.email, style: TextStyle(color: Colors.white.withValues(alpha: 0.9))),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            child: Column(
              children: [
                _ModernField(controller: _firstNameController, label: 'First Name', icon: Icons.person_outline_rounded, validator: _required),
                const SizedBox(height: 14),
                _ModernField(controller: _lastNameController, label: 'Last Name', icon: Icons.person_2_outlined, validator: _required),
                const SizedBox(height: 14),
                _ModernField(controller: _displayNameController, label: 'Display Name', icon: Icons.badge_outlined, validator: _required),
                const SizedBox(height: 14),
                _ModernField(controller: _usernameController, label: 'Username', icon: Icons.alternate_email_rounded, validator: _required),
                const SizedBox(height: 14),
                _ModernField(
                  controller: _phoneController,
                  label: 'Phone Number',
                  icon: Icons.phone_outlined,
                  keyboardType: TextInputType.phone,
                  validator: _required,
                ),
                const SizedBox(height: 90),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String? _required(String? value) => value == null || value.trim().isEmpty ? 'This field is required' : null;
}

class _ModernField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final IconData icon;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;

  const _ModernField({required this.controller, required this.label, required this.icon, this.keyboardType, this.validator});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textInputAction: TextInputAction.next,
      validator: validator,
      decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon)),
    );
  }
}
