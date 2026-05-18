import 'package:flutter/material.dart';

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
  final ProfileApiService service = ProfileApiService();
  final formKey = GlobalKey<FormState>();

  late final TextEditingController usernameController;
  late final TextEditingController emailController;
  late final TextEditingController firstNameController;
  late final TextEditingController lastNameController;
  late final TextEditingController phoneController;

  bool isLoading = false;

  Future<void> updateProfile() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isLoading = true;
    });

    try {
      final localUpdatedProfile = widget.profile.copyWith(
        username: usernameController.text.trim(),
        email: emailController.text.trim(),
        firstName: firstNameController.text.trim(),
        lastName: lastNameController.text.trim(),
        displayName:
            '${firstNameController.text.trim()} ${lastNameController.text.trim()}',
        phoneNumber: phoneController.text.trim(),
      );

      final response = await service.updateProfileDemo(
        profile: localUpdatedProfile,
      );

      final apiProfile = service.parseProfile(response);

      if (!mounted) return;

      AppToast.show(
        context,
        message: response['message'] ?? 'Profile updated successfully',
        type: ToastType.success,
      );

      Navigator.pop(context, apiProfile ?? localUpdatedProfile);
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
  void initState() {
    super.initState();

    usernameController = TextEditingController(text: widget.profile.username);
    emailController = TextEditingController(text: widget.profile.email);
    firstNameController = TextEditingController(text: widget.profile.firstName);
    lastNameController = TextEditingController(text: widget.profile.lastName);
    phoneController = TextEditingController(text: widget.profile.phoneNumber);
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  Widget _field({
    required String label,
    required TextEditingController controller,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: controller,
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
      appBar: AppBar(title: const Text('Edit Profile')),
      body: Form(
        key: formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _field(label: 'Username', controller: usernameController),
            _field(label: 'First Name', controller: firstNameController),
            _field(label: 'Last Name', controller: lastNameController),
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
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : updateProfile,
              child: isLoading
                  ? const SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(strokeWidth: 2.4),
                    )
                  : const Text('Update Profile'),
            ),
          ],
        ),
      ),
    );
  }
}
