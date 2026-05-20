import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../features/notifications/screens/notification_list_screen.dart';
import '../../../features/support/screens/help_center_screen.dart';

class CommonAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool centerTitle;
  final List<Widget>? actions;
  final bool hasUnreadNotifications;

  const CommonAppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.centerTitle = false,
    this.actions,
    this.hasUnreadNotifications = false,
  });

  @override
  Size get preferredSize =>
      Size.fromHeight(subtitle == null ? AppDimens.appBarHeight + 6 : 78);

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.isDarkMode(context);
    final topColor = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;
    final textColor = isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: isDark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
      child: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 260),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              color: topColor.withValues(alpha: 0.88),
              border: Border(
                bottom: BorderSide(
                  color: (isDark ? AppColors.darkBorder : AppColors.lightBorder)
                      .withValues(alpha: 0.7),
                  width: 0.6,
                ),
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: SizedBox(
                height: preferredSize.height,
                child: Row(
                  children: [
                    if (showBackButton)
                      Padding(
                        padding: const EdgeInsets.only(left: 10),
                        child: _AnimatedHeaderButton(
                          icon: Icons.arrow_back_ios_new_rounded,
                          tooltip: 'Back',
                          isDark: isDark,
                          onTap: () => Navigator.maybePop(context),
                          size: 19,
                        ),
                      )
                    else
                      const SizedBox(width: AppDimens.spaceMD),
                    Expanded(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 260),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 0.12),
                                end: Offset.zero,
                              ).animate(animation),
                              child: child,
                            ),
                          );
                        },
                        child: Align(
                          key: ValueKey('$title-$subtitle'),
                          alignment: centerTitle
                              ? Alignment.center
                              : Alignment.centerLeft,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: centerTitle
                                ? CrossAxisAlignment.center
                                : CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: textColor,
                                  fontSize: subtitle == null ? 22 : 20,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.45,
                                ),
                              ),
                              if (subtitle != null) ...[
                                const SizedBox(height: 2),
                                Text(
                                  subtitle!,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    color: isDark
                                        ? AppColors.darkTextSecondary
                                        : AppColors.lightTextSecondary,
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ),
                    ),
                    ...(actions ?? _defaultActions(context, isDark)),
                    const SizedBox(width: 10),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _defaultActions(BuildContext context, bool isDark) {
    return [
      ValueListenableBuilder<ThemeMode>(
        valueListenable: ThemeController.themeMode,
        builder: (context, _, _) {
          return _AnimatedHeaderButton(
            icon: ThemeController.toggleIcon(context),
            tooltip: ThemeController.toggleTooltip(context),
            isDark: isDark,
            onTap: ThemeController.toggleTheme,
          );
        },
      ),
      _NotificationButton(
        isDark: isDark,
        hasUnread: hasUnreadNotifications,
        onTap: () =>
            Navigator.push(context, _softRoute(const NotificationListScreen())),
      ),
      _AnimatedHeaderButton(
        icon: Icons.headset_mic_outlined,
        tooltip: 'Help & Support',
        isDark: isDark,
        onTap: () =>
            Navigator.push(context, _softRoute(const HelpCenterScreen())),
      ),
    ];
  }

  static Route<void> _softRoute(Widget page) {
    return PageRouteBuilder<void>(
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 260),
      reverseTransitionDuration: const Duration(milliseconds: 220),
      transitionsBuilder: (_, animation, _, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curved,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0, 0.03),
              end: Offset.zero,
            ).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

class _AnimatedHeaderButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final bool isDark;
  final VoidCallback onTap;
  final double size;

  const _AnimatedHeaderButton({
    required this.icon,
    required this.tooltip,
    required this.isDark,
    required this.onTap,
    this.size = 22,
  });

  @override
  State<_AnimatedHeaderButton> createState() => _AnimatedHeaderButtonState();
}

class _AnimatedHeaderButtonState extends State<_AnimatedHeaderButton> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    final fg = widget.isDark
        ? AppColors.darkTextPrimary
        : AppColors.lightTextPrimary;
    final bg = widget.isDark
        ? AppColors.darkSurfaceVariant
        : AppColors.lightSurface;
    final border = widget.isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return Tooltip(
      message: widget.tooltip,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _pressed = true),
        onTapCancel: () => setState(() => _pressed = false),
        onTapUp: (_) => setState(() => _pressed = false),
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        child: AnimatedScale(
          duration: const Duration(milliseconds: 140),
          scale: _pressed ? 0.92 : 1,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            width: 40,
            height: 40,
            margin: const EdgeInsets.only(left: 8),
            decoration: BoxDecoration(
              color: bg.withValues(alpha: widget.isDark ? 0.82 : 0.95),
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: border.withValues(alpha: 0.72)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: widget.isDark ? 0.14 : 0.055,
                  ),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(widget.icon, size: widget.size, color: fg),
          ),
        ),
      ),
    );
  }
}

class _NotificationButton extends StatelessWidget {
  final bool isDark;
  final bool hasUnread;
  final VoidCallback onTap;

  const _NotificationButton({
    required this.isDark,
    required this.hasUnread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        _AnimatedHeaderButton(
          icon: Icons.notifications_none_rounded,
          tooltip: 'Notifications',
          isDark: isDark,
          onTap: onTap,
        ),
        if (hasUnread)
          Positioned(
            top: 3,
            right: -1,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0.4, end: 1),
              duration: const Duration(milliseconds: 360),
              curve: Curves.elasticOut,
              builder: (_, value, child) =>
                  Transform.scale(scale: value, child: child),
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isDark
                        ? AppColors.darkBackground
                        : AppColors.lightBackground,
                    width: 2,
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
