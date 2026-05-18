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
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileApiService service = ProfileApiService();

  bool isLoading = true;
  bool isAvatarLoading = false;

  ProfileModel? profile;

  Future<void> fetchProfile() async {
    setState(() {
      isLoading = true;
    });

    try {
      final result = await service.getProfile();

      if (!mounted) return;

      setState(() {
        profile = result;
      });
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

  Future<void> uploadAvatar() async {
    setState(() {
      isAvatarLoading = true;
    });

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
        message: response['message'] ?? 'Avatar uploaded successfully',
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
        setState(() {
          isAvatarLoading = false;
        });
      }
    }
  }

  Future<void> openEditProfile(ProfileModel profile) async {
    final updatedProfile = await Navigator.push<ProfileModel>(
      context,
      MaterialPageRoute(builder: (_) => EditProfileScreen(profile: profile)),
    );

    if (updatedProfile != null) {
      setState(() {
        this.profile = updatedProfile;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final user = profile;

    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : user == null
          ? const Center(child: Text('Profile not found'))
          : RefreshIndicator(
              onRefresh: fetchProfile,
              child: ListView(
                padding: const EdgeInsets.all(20),
                children: [
                  Container(
                    padding: const EdgeInsets.all(22),
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(24),
                    ),
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              radius: 52,
                              backgroundColor: Colors.white,
                              backgroundImage: user.avatarUrl != null
                                  ? NetworkImage(user.avatarUrl!)
                                  : null,
                              child: user.avatarUrl == null
                                  ? const Icon(
                                      Icons.person_rounded,
                                      size: 52,
                                      color: AppColors.primary,
                                    )
                                  : null,
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: InkWell(
                                onTap: isAvatarLoading ? null : uploadAvatar,
                                child: CircleAvatar(
                                  backgroundColor: AppColors.primary,
                                  child: isAvatarLoading
                                      ? const SizedBox(
                                          width: 18,
                                          height: 18,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            color: Colors.white,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.camera_alt_rounded,
                                          color: Colors.white,
                                        ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Text(
                          user.displayName,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.email,
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          user.phoneNumber,
                          style: const TextStyle(
                            color: AppColors.lightTextSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 22),
                  ProfileMenuTile(
                    icon: Icons.edit_rounded,
                    title: 'Edit Profile',
                    subtitle: 'Update name, email and phone',
                    onTap: () {
                      openEditProfile(user);
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.lock_rounded,
                    title: 'Change Password',
                    subtitle: 'Update your account password',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ChangePasswordScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.notifications_rounded,
                    title: 'Notification Settings',
                    subtitle: 'Manage alerts and preferences',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const NotificationSettingsScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.location_on_rounded,
                    title: 'My Addresses',
                    subtitle: 'Manage delivery addresses',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AddressListScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.receipt_long_rounded,
                    title: 'My Orders',
                    subtitle: 'View order history and tracking',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const MyOrdersScreen(),
                        ),
                      );
                    },
                  ),
                  ProfileMenuTile(
                    icon: Icons.settings_rounded,
                    title: 'Account Settings',
                    subtitle: 'Account status and delete account',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AccountSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
