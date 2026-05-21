import 'package:flutter/material.dart';

import '../../../app/routes.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme_palette.dart';
import '../../../core/theme/theme_controller.dart';

class AdminAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final List<Widget> extraActions;
  final bool showThemeMenu;
  final bool showLogout;

  const AdminAppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.extraActions = const [],
    this.showThemeMenu = true,
    this.showLogout = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 72 : 82);

  void _logout(BuildContext context) {
    final palette = context.palette;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: palette.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      builder: (sheetContext) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(22, 10, 22, 26),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: AppColors.danger.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.danger,
                ),
              ),

              const SizedBox(height: 16),

              Text(
                'Logout from admin?',
                style: TextStyle(
                  color: palette.textPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                'You will need to sign in again to access the admin panel.',
                style: TextStyle(color: palette.textSecondary, height: 1.4),
              ),

              const SizedBox(height: 22),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(sheetContext),
                      child: const Text('Cancel'),
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: FilledButton.icon(
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColors.danger,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: () {
                        Navigator.pop(sheetContext);
                        Navigator.pushNamedAndRemoveUntil(
                          context,
                          AppRoutes.adminLogin,
                          (route) => false,
                        );
                      },
                      icon: const Icon(Icons.logout_rounded, size: 18),
                      label: const Text('Logout'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    final canPop = Navigator.canPop(context);
    final shouldShowBackButton = showBackButton && canPop;

    return AppBar(
      automaticallyImplyLeading: false,
      centerTitle: false,
      elevation: 0,
      toolbarHeight: preferredSize.height,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: palette.textPrimary,
      surfaceTintColor: Colors.transparent,
      titleSpacing: 16,
      title: Row(
        children: [
          if (shouldShowBackButton) ...[
            _HeaderIconButton(
              tooltip: 'Back',
              icon: Icons.arrow_back_rounded,
              color: palette.primary,
              onTap: () => Navigator.maybePop(context),
            ),
            const SizedBox(width: 10),
          ],

          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              gradient: palette.primaryGradient,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: palette.primary.withValues(alpha: 0.18),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: const Icon(
              Icons.admin_panel_settings_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 18,
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w900,
                  ),
                ),

                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      color: palette.textSecondary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
      actions: [
        ...extraActions,

        if (showThemeMenu) const _AdminThemeMenu(),

        if (showLogout)
          _HeaderIconButton(
            tooltip: 'Logout',
            icon: Icons.logout_rounded,
            color: AppColors.danger,
            onTap: () => _logout(context),
            danger: true,
          ),

        const SizedBox(width: 10),
      ],
      flexibleSpace: SafeArea(
        bottom: false,
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            height: 1,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            decoration: BoxDecoration(
              color: palette.border.withValues(alpha: 0.75),
              boxShadow: [
                BoxShadow(
                  color: palette.surface.withValues(alpha: 0.92),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _AdminThemeMenu extends StatelessWidget {
  const _AdminThemeMenu();

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeVariant>(
      valueListenable: ThemeController.themeVariant,
      builder: (context, selectedTheme, _) {
        final palette = AppThemePalettes.byVariant(selectedTheme);

        return PopupMenuButton<AppThemeVariant>(
          tooltip: ThemeController.currentTooltip(),
          position: PopupMenuPosition.under,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          onSelected: ThemeController.setTheme,
          itemBuilder: (context) {
            return AppThemeVariant.values.map((theme) {
              final itemPalette = AppThemePalettes.byVariant(theme);
              final selected = selectedTheme == theme;

              return PopupMenuItem<AppThemeVariant>(
                value: theme,
                child: Row(
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: itemPalette.primaryGradient,
                        border: Border.all(
                          color: selected
                              ? itemPalette.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Text(
                        ThemeController.variantLabel(theme),
                        style: TextStyle(
                          fontWeight: selected
                              ? FontWeight.w900
                              : FontWeight.w600,
                        ),
                      ),
                    ),

                    if (selected)
                      Icon(
                        Icons.check_rounded,
                        size: 18,
                        color: itemPalette.primary,
                      ),
                  ],
                ),
              );
            }).toList();
          },
          child: Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: palette.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.22),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                ThemeController.currentIcon(),
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  final String tooltip;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool danger;

  const _HeaderIconButton({
    required this.tooltip,
    required this.icon,
    required this.color,
    required this.onTap,
    this.danger = false,
  });

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;

    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: Material(
        color: color.withValues(alpha: palette.isDark ? 0.16 : 0.10),
        borderRadius: BorderRadius.circular(15),
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: onTap,
          child: Tooltip(
            message: tooltip,
            child: SizedBox(
              width: 42,
              height: 42,
              child: Icon(icon, color: color, size: 21),
            ),
          ),
        ),
      ),
    );
  }
}
