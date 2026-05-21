import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_user_model.dart';
import '../services/admin_user_api_service.dart';

class AdminUserRoleScreen extends StatefulWidget {
  final AdminUserListItemModel user;

  const AdminUserRoleScreen({super.key, required this.user});

  @override
  State<AdminUserRoleScreen> createState() => _AdminUserRoleScreenState();
}

class _AdminUserRoleScreenState extends State<AdminUserRoleScreen> {
  final AdminUserApiService service = AdminUserApiService();
  final List<String> roles = const ['customer', 'manager', 'admin'];

  bool isLoading = false;
  late String selectedRole;

  @override
  void initState() {
    super.initState();
    selectedRole = widget.user.role.isEmpty ? 'customer' : widget.user.role;
  }

  Future<void> updateRole() async {
    setState(() => isLoading = true);
    try {
      final response = await service.updateRole(userId: widget.user.id, role: selectedRole);
      final updatedRole = service.parseUpdatedRole(response) ?? selectedRole;
      if (!mounted) return;
      AppToast.show(context, message: response['message']?.toString() ?? 'User role updated successfully', type: ToastType.success);
      Navigator.pop(context, widget.user.copyWith(role: updatedRole));
    } catch (error) {
      if (!mounted) return;
      AppToast.show(context, message: error.toString().replaceAll('Exception: ', ''), type: ToastType.error);
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Scaffold(
      appBar: AppBar(title: const Text('Manage User Role')),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 10, 20, 16),
          child: FilledButton.icon(
            onPressed: isLoading ? null : updateRole,
            icon: isLoading
                ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.save_rounded),
            label: const Text('Update Role'),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(gradient: AppColors.primaryGradient, borderRadius: BorderRadius.circular(30)),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 34,
                  backgroundColor: Colors.white.withValues(alpha: 0.18),
                  backgroundImage: widget.user.avatarUrl == null ? null : NetworkImage(widget.user.avatarUrl!),
                  child: widget.user.avatarUrl == null
                      ? Text(widget.user.initials, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 20))
                      : null,
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                    Text(widget.user.displayName, style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 4),
                    Text(widget.user.email, maxLines: 1, overflow: TextOverflow.ellipsis, style: TextStyle(color: Colors.white.withValues(alpha: 0.85))),
                  ]),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Text('Choose Role', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
          const SizedBox(height: 12),
          ...roles.map((role) {
            final selected = selectedRole == role;
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Material(
                color: selected
                    ? AppColors.primary.withValues(alpha: 0.12)
                    : isDark
                        ? AppColors.darkSurface
                        : AppColors.lightSurface,
                borderRadius: BorderRadius.circular(22),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => setState(() => selectedRole = role),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: selected ? AppColors.primary : AppColors.primary.withValues(alpha: 0.10),
                          child: Icon(_roleIcon(role), color: selected ? Colors.white : AppColors.primary),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                            Text(role.toUpperCase(), style: const TextStyle(fontWeight: FontWeight.w900)),
                            const SizedBox(height: 3),
                            Text(_roleDescription(role)),
                          ]),
                        ),
                        Icon(selected ? Icons.check_circle_rounded : Icons.circle_outlined, color: selected ? AppColors.primary : AppColors.muted),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  IconData _roleIcon(String role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings_rounded;
      case 'manager':
        return Icons.manage_accounts_rounded;
      default:
        return Icons.person_rounded;
    }
  }

  String _roleDescription(String role) {
    switch (role) {
      case 'admin':
        return 'Full access to admin modules and settings';
      case 'manager':
        return 'Can manage products, orders and customers';
      default:
        return 'Standard customer shopping account';
    }
  }
}
