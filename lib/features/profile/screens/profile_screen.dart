import 'package:dewmii/shared/widgets/navigation/common_app_header.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../shared/widgets/app_toast.dart';
import '../../address/screens/address_list_screen.dart';
import '../../order/screens/my_orders_screen.dart';
import '../models/profile_model.dart';
import '../services/profile_api_service.dart';
import '../widgets/profile_menu_tile.dart';
import 'account_settings_screen.dart';
import 'change_password_screen.dart';
import 'edit_profile_screen.dart';
import 'notification_settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  final bool showCommonScaffold;

  const ProfileScreen({super.key, this.showCommonScaffold = true});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final ProfileApiService service = ProfileApiService();

  bool isLoading = true;
  bool isAvatarLoading = false;
  ProfileModel? profile;

  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    fetchProfile();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> fetchProfile() async {
    setState(() => isLoading = true);

    try {
      final result = await service.getProfile();

      if (!mounted) return;

      setState(() => profile = result);
      _controller.forward(from: 0);
    } catch (error) {
      if (!mounted) return;

      AppToast.show(
        context,
        message: error.toString().replaceAll('Exception: ', ''),
        type: ToastType.error,
      );
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  Future<void> uploadAvatar() async {
    setState(() => isAvatarLoading = true);

    try {
      final response = await service.uploadAvatarDemo();
      final avatarUrl = service.parseAvatarUrl(response);

      if (!mounted) return;

      setState(() {
        if (profile != null && avatarUrl != null) {
          profile = profile!.copyWith(avatarUrl: avatarUrl);
        }
      });

      AppToast.show(
        context,
        message:
            response['message']?.toString() ?? 'Avatar uploaded successfully',
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
      if (mounted) {
        setState(() => isAvatarLoading = false);
      }
    }
  }

  Future<void> openEditProfile(ProfileModel profile) async {
    final updatedProfile = await Navigator.push<ProfileModel>(
      context,
      _route(EditProfileScreen(profile: profile)),
    );

    if (updatedProfile != null) {
      setState(() => this.profile = updatedProfile);
    }
  }

  Route<T> _route<T>(Widget page) {
    return PageRouteBuilder<T>(
      pageBuilder: (_, animation, _) => page,
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(
          opacity: CurvedAnimation(
            parent: animation,
            curve: Curves.easeOutCubic,
          ),
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.04),
              end: Offset.zero,
            ).animate(animation),
            child: child,
          ),
        );
      },
    );
  }

  Widget _menuTileWithGap(Widget child) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, right: 4, bottom: 10),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final content = RefreshIndicator(
      onRefresh: fetchProfile,
      child: _buildBody(context),
    );

    if (!widget.showCommonScaffold) return content;

    return Scaffold(
      appBar: const CommonAppHeader(title: 'Profile'),
      body: content,
    );
  }

  Widget _buildBody(BuildContext context) {
    if (isLoading) return const _ProfileSkeleton();

    final current = profile;

    if (current == null) {
      return _EmptyProfile(onRetry: fetchProfile);
    }

    return FadeTransition(
      opacity: _fadeAnimation,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
        children: [
          _ProfileHero(
            profile: current,
            isAvatarLoading: isAvatarLoading,
            onEdit: () => openEditProfile(current),
            onAvatarTap: uploadAvatar,
          ),

          const SizedBox(height: 18),

          _StatsStrip(profile: current),

          const SizedBox(height: 24),

          const Text(
            'My Account',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 12),

          _menuTileWithGap(
            ProfileMenuTile(
              icon: Icons.shopping_bag_outlined,
              title: 'My Orders',
              subtitle: 'Track orders, invoices and returns',
              onTap: () =>
                  Navigator.push(context, _route(const MyOrdersScreen())),
            ),
          ),

          _menuTileWithGap(
            ProfileMenuTile(
              icon: Icons.location_on_outlined,
              title: 'Saved Addresses',
              subtitle: 'Manage delivery addresses',
              onTap: () =>
                  Navigator.push(context, _route(const AddressListScreen())),
            ),
          ),

          _menuTileWithGap(
            ProfileMenuTile(
              icon: Icons.notifications_outlined,
              title: 'Notification Settings',
              subtitle: 'Choose your preferred alerts',
              onTap: () => Navigator.push(
                context,
                _route(const NotificationSettingsScreen()),
              ),
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            'Security',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900),
          ),

          const SizedBox(height: 12),

          _menuTileWithGap(
            ProfileMenuTile(
              icon: Icons.lock_outline_rounded,
              title: 'Change Password',
              subtitle: 'Update your account password',
              onTap: () =>
                  Navigator.push(context, _route(const ChangePasswordScreen())),
            ),
          ),

          _menuTileWithGap(
            ProfileMenuTile(
              icon: Icons.manage_accounts_outlined,
              title: 'Account Settings',
              subtitle: 'Logout, deactivate or delete account',
              onTap: () => Navigator.push(
                context,
                _route(const AccountSettingsScreen()),
              ),
              iconColor: AppColors.warning,
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileHero extends StatelessWidget {
  final ProfileModel profile;
  final bool isAvatarLoading;
  final VoidCallback onEdit;
  final VoidCallback onAvatarTap;

  const _ProfileHero({
    required this.profile,
    required this.isAvatarLoading,
    required this.onEdit,
    required this.onAvatarTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: isDark
            ? AppColors.darkHeroGradient
            : AppColors.primaryGradient,
        borderRadius: BorderRadius.circular(34),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  CircleAvatar(
                    radius: 42,
                    backgroundColor: Colors.white.withValues(alpha: 0.22),
                    backgroundImage: profile.avatarUrl == null
                        ? null
                        : NetworkImage(profile.avatarUrl!),
                    child: profile.avatarUrl == null
                        ? Text(
                            profile.initials,
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Material(
                      color: Colors.white,
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: isAvatarLoading ? null : onAvatarTap,
                        child: Padding(
                          padding: const EdgeInsets.all(7),
                          child: isAvatarLoading
                              ? const SizedBox(
                                  width: 15,
                                  height: 15,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(
                                  Icons.camera_alt_rounded,
                                  size: 17,
                                  color: AppColors.primary,
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      profile.fullName,
                      style: const TextStyle(
                        fontSize: 22,
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      profile.email,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.88),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _Pill(
                          text: profile.status.isEmpty
                              ? 'Active'
                              : profile.status,
                        ),
                        if (profile.emailVerified)
                          const _Pill(text: 'Verified'),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 22),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
              ),
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Edit Profile'),
            ),
          ),
        ],
      ),
    );
  }
}

class _Pill extends StatelessWidget {
  final String text;

  const _Pill({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _StatsStrip extends StatelessWidget {
  final ProfileModel profile;

  const _StatsStrip({required this.profile});

  @override
  Widget build(BuildContext context) {
    final created = profile.createdAt == null
        ? 'New'
        : '${profile.createdAt!.year}';

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            label: 'Role',
            value: profile.role.isEmpty ? 'Customer' : profile.role,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _StatCard(label: 'Member Since', value: created),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;

  const _StatCard({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark
                  ? AppColors.darkTextSecondary
                  : AppColors.lightTextSecondary,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ProfileSkeleton extends StatelessWidget {
  const _ProfileSkeleton();

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: List.generate(
        6,
        (index) => Container(
          margin: const EdgeInsets.only(bottom: 14),
          height: index == 0 ? 180 : 76,
          decoration: BoxDecoration(
            color: AppColors.shimmerBase.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(index == 0 ? 32 : 22),
          ),
        ),
      ),
    );
  }
}

class _EmptyProfile extends StatelessWidget {
  final VoidCallback onRetry;

  const _EmptyProfile({required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_off_outlined,
              size: 72,
              color: AppColors.primary,
            ),
            const SizedBox(height: 14),
            const Text(
              'Profile not found',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 8),
            const Text(
              'Pull to refresh or try again.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 18),
            FilledButton(onPressed: onRetry, child: const Text('Try Again')),
          ],
        ),
      ),
    );
  }
}
