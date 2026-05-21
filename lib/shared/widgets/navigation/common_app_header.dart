import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_palette.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../features/notifications/screens/notification_list_screen.dart';
import '../../../features/support/screens/help_center_screen.dart';

class CommonAppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final bool showBackButton;
  final bool centerTitle;

  final List<Widget>? actions;
  final List<Widget> extraActions;

  final bool showDefaultActions;
  final bool showThemeMenu;

  const CommonAppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBackButton = false,
    this.centerTitle = false,
    this.actions,
    this.extraActions = const [],
    this.showDefaultActions = true,
    this.showThemeMenu = true,
  });

  @override
  Size get preferredSize => Size.fromHeight(subtitle == null ? 60 : 68);

  @override
  Widget build(BuildContext context) {
    final palette = context.palette;
    final customActions = actions ?? extraActions;

    return AppBar(
      automaticallyImplyLeading: showBackButton,
      centerTitle: centerTitle,
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      foregroundColor: palette.textPrimary,
      surfaceTintColor: Colors.transparent,
      titleSpacing: showBackButton ? 0 : 16,
      title: Column(
        crossAxisAlignment: centerTitle
            ? CrossAxisAlignment.center
            : CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: palette.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w900,
              letterSpacing: -0.4,
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
                fontWeight: FontWeight.w600,
                color: palette.textSecondary,
              ),
            ),
          ],
        ],
      ),
      actions: [
        ...customActions,
        if (showThemeMenu) const _SingleThemeMenu(),
        if (showDefaultActions) ...[
          IconButton(
            tooltip: 'Notifications',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationListScreen(),
                ),
              );
            },
            icon: const Icon(Icons.notifications_outlined),
          ),
          IconButton(
            tooltip: 'Help',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpCenterScreen()),
              );
            },
            icon: const Icon(Icons.help_outline_rounded),
          ),
        ],
        const SizedBox(width: 6),
      ],
    );
  }
}

class _SingleThemeMenu extends StatelessWidget {
  const _SingleThemeMenu();

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
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: palette.primaryGradient,
                boxShadow: [
                  BoxShadow(
                    color: palette.primary.withValues(alpha: 0.24),
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
