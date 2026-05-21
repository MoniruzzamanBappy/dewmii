import 'package:dewmii/features/admin/user_management/screens/admin_customer_details_screen.dart';
import 'package:dewmii/features/admin/user_management/screens/admin_user_role_screen.dart';
import 'package:dewmii/shared/widgets/admin_navigation/admin_app_header.dart';
import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../shared/widgets/app_toast.dart';
import '../models/admin_user_model.dart';
import '../services/admin_user_api_service.dart';
import '../widgets/admin_customer_card.dart';

class AdminCustomerListScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const AdminCustomerListScreen({super.key, this.showCommonScaffold = true});

  @override
  State<AdminCustomerListScreen> createState() =>
      _AdminCustomerListScreenState();
}

class _AdminCustomerListScreenState extends State<AdminCustomerListScreen>
    with SingleTickerProviderStateMixin {
  final AdminUserApiService service = AdminUserApiService();
  final TextEditingController searchController = TextEditingController();
  late final AnimationController _controller;
  late final Animation<double> _fade;

  bool isLoading = true;
  bool isActionLoading = false;
  String selectedStatus = 'all';
  String selectedRole = 'all';

  List<AdminUserListItemModel> users = [];
  List<AdminUserListItemModel> filteredUsers = [];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _fade = CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic);
    fetchUsers();
  }

  @override
  void dispose() {
    _controller.dispose();
    searchController.dispose();
    super.dispose();
  }

  Future<void> fetchUsers() async {
    setState(() => isLoading = true);
    try {
      final result = await service.getUsers();
      if (!mounted) return;
      setState(() {
        users = result;
        _applyFilters();
      });
      _controller.forward(from: 0);
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isLoading = false);
    }
  }

  void _applyFilters() {
    final keyword = searchController.text.trim().toLowerCase();
    filteredUsers = users.where((user) {
      final matchesSearch =
          keyword.isEmpty ||
          user.displayName.toLowerCase().contains(keyword) ||
          user.email.toLowerCase().contains(keyword) ||
          user.phoneNumber.toLowerCase().contains(keyword) ||
          user.username.toLowerCase().contains(keyword) ||
          user.role.toLowerCase().contains(keyword) ||
          user.status.toLowerCase().contains(keyword);
      final matchesStatus =
          selectedStatus == 'all' ||
          user.status.toLowerCase() == selectedStatus;
      final matchesRole =
          selectedRole == 'all' || user.role.toLowerCase() == selectedRole;
      return matchesSearch && matchesStatus && matchesRole;
    }).toList();
  }

  void searchUsers(String value) => setState(_applyFilters);

  Future<bool> _confirmStatus(
    AdminUserListItemModel user,
    String nextStatus,
  ) async {
    final isBlocking = nextStatus == 'blocked';
    return await showModalBottomSheet<bool>(
          context: context,
          showDragHandle: true,
          builder: (context) => Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isBlocking ? Icons.block_rounded : Icons.lock_open_rounded,
                  size: 44,
                  color: isBlocking ? AppColors.error : AppColors.success,
                ),
                const SizedBox(height: 10),
                Text(
                  isBlocking ? 'Block user?' : 'Unblock user?',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Are you sure you want to ${isBlocking ? 'block' : 'unblock'} ${user.displayName}?',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text(isBlocking ? 'Block' : 'Unblock'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ) ??
        false;
  }

  Future<void> updateStatus(AdminUserListItemModel user) async {
    final nextStatus = user.status == 'blocked' ? 'active' : 'blocked';
    if (!await _confirmStatus(user, nextStatus)) return;
    setState(() => isActionLoading = true);
    try {
      final response = await service.updateStatus(
        userId: user.id,
        status: nextStatus,
        reason: nextStatus == 'blocked'
            ? 'Suspicious activity'
            : 'Account reviewed',
      );
      final updatedStatus = service.parseUpdatedStatus(response) ?? nextStatus;
      if (!mounted) return;
      setState(() {
        users = users
            .map(
              (item) => item.id == user.id
                  ? item.copyWith(status: updatedStatus)
                  : item,
            )
            .toList();
        _applyFilters();
      });
      AppToast.show(
        context,
        message:
            response['message']?.toString() ??
            'User status updated successfully',
        type: ToastType.success,
      );
    } catch (error) {
      if (!mounted) return;
      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) setState(() => isActionLoading = false);
    }
  }

  Future<void> openRoleScreen(AdminUserListItemModel user) async {
    final updatedUser = await Navigator.push<AdminUserListItemModel>(
      context,
      _route(AdminUserRoleScreen(user: user)),
    );
    if (updatedUser != null) {
      setState(() {
        users = users
            .map((item) => item.id == updatedUser.id ? updatedUser : item)
            .toList();
        _applyFilters();
      });
    }
  }

  Future<void> openDetails(AdminUserListItemModel user) async {
    final updatedUser = await Navigator.push<AdminUserListItemModel>(
      context,
      _route(AdminCustomerDetailsScreen(userId: user.id, fallbackUser: user)),
    );
    if (updatedUser != null) {
      setState(() {
        users = users
            .map((item) => item.id == updatedUser.id ? updatedUser : item)
            .toList();
        _applyFilters();
      });
    }
  }

  Route<T> _route<T>(Widget page) => PageRouteBuilder<T>(
    pageBuilder: (_, animation, _) => page,
    transitionsBuilder: (_, animation, _, child) => FadeTransition(
      opacity: CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.04),
          end: Offset.zero,
        ).animate(animation),
        child: child,
      ),
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AdminAppHeader(
        title: 'Users',
        subtitle: 'Manage customers, status and roles',
        showBackButton: widget.showCommonScaffold,
      ),
      body: isLoading
          ? const _UserSkeleton()
          : RefreshIndicator(
              onRefresh: fetchUsers,
              child: FadeTransition(
                opacity: _fade,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                  children: [
                    if (isActionLoading) ...[
                      const LinearProgressIndicator(),
                      const SizedBox(height: 14),
                    ],
                    _UsersHero(users: users, filtered: filteredUsers),
                    const SizedBox(height: 16),
                    TextField(
                      controller: searchController,
                      onChanged: searchUsers,
                      decoration: InputDecoration(
                        hintText: 'Search user, email, phone, role or status',
                        prefixIcon: const Icon(Icons.search_rounded),
                        suffixIcon: searchController.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  searchController.clear();
                                  searchUsers('');
                                },
                                icon: const Icon(Icons.close_rounded),
                              ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          _FilterChip(
                            label: 'All',
                            selected: selectedStatus == 'all',
                            onTap: () => setState(() {
                              selectedStatus = 'all';
                              _applyFilters();
                            }),
                          ),
                          _FilterChip(
                            label: 'Active',
                            selected: selectedStatus == 'active',
                            onTap: () => setState(() {
                              selectedStatus = 'active';
                              _applyFilters();
                            }),
                          ),
                          _FilterChip(
                            label: 'Blocked',
                            selected: selectedStatus == 'blocked',
                            onTap: () => setState(() {
                              selectedStatus = 'blocked';
                              _applyFilters();
                            }),
                          ),
                          _FilterChip(
                            label: 'Admins',
                            selected: selectedRole == 'admin',
                            onTap: () => setState(() {
                              selectedRole = selectedRole == 'admin'
                                  ? 'all'
                                  : 'admin';
                              _applyFilters();
                            }),
                          ),
                          _FilterChip(
                            label: 'Customers',
                            selected: selectedRole == 'customer',
                            onTap: () => setState(() {
                              selectedRole = selectedRole == 'customer'
                                  ? 'all'
                                  : 'customer';
                              _applyFilters();
                            }),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (filteredUsers.isEmpty)
                      _EmptyUsers(onRetry: fetchUsers)
                    else
                      ...filteredUsers.map(
                        (user) => AdminCustomerCard(
                          user: user,
                          onTap: () => openDetails(user),
                          onStatus: () => updateStatus(user),
                          onRole: () => openRoleScreen(user),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}

class _UsersHero extends StatelessWidget {
  final List<AdminUserListItemModel> users;
  final List<AdminUserListItemModel> filtered;
  const _UsersHero({required this.users, required this.filtered});

  @override
  Widget build(BuildContext context) {
    final active = users.where((e) => e.status == 'active').length;
    final blocked = users.where((e) => e.status == 'blocked').length;
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Customers & Users',
            style: TextStyle(
              color: Colors.white,
              fontSize: 23,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _HeroCount(label: 'Total', value: '${users.length}'),
              ),
              Expanded(
                child: _HeroCount(label: 'Active', value: '$active'),
              ),
              Expanded(
                child: _HeroCount(label: 'Blocked', value: '$blocked'),
              ),
              Expanded(
                child: _HeroCount(
                  label: 'Showing',
                  value: '${filtered.length}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroCount extends StatelessWidget {
  final String label;
  final String value;
  const _HeroCount({required this.label, required this.value});
  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        value,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w900,
          fontSize: 20,
        ),
      ),
      Text(
        label,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.82),
          fontWeight: FontWeight.w700,
        ),
      ),
    ],
  );
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(right: 8),
    child: ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onTap(),
    ),
  );
}

class _EmptyUsers extends StatelessWidget {
  final VoidCallback onRetry;
  const _EmptyUsers({required this.onRetry});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(top: 80),
    child: Column(
      children: [
        const Icon(
          Icons.people_outline_rounded,
          size: 70,
          color: AppColors.primary,
        ),
        const SizedBox(height: 12),
        const Text(
          'No users found',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
        ),
        const SizedBox(height: 12),
        FilledButton(onPressed: onRetry, child: const Text('Refresh')),
      ],
    ),
  );
}

class _UserSkeleton extends StatelessWidget {
  const _UserSkeleton();
  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(20),
    children: List.generate(
      6,
      (index) => Container(
        margin: const EdgeInsets.only(bottom: 14),
        height: index == 0 ? 150 : 118,
        decoration: BoxDecoration(
          color: AppColors.shimmerBase.withValues(alpha: 0.45),
          borderRadius: BorderRadius.circular(index == 0 ? 30 : 24),
        ),
      ),
    ),
  );
}
