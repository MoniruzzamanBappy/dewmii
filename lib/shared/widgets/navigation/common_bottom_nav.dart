import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/theme_controller.dart';

class NavItem {
  final IconData icon;
  final IconData selectedIcon;
  final String label;
  final int? badgeCount;

  const NavItem({
    required this.icon,
    required this.selectedIcon,
    required this.label,
    this.badgeCount,
  });
}

class CommonBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final List<int?> badgeCounts;

  static const List<NavItem> _items = [
    NavItem(
      icon: Icons.home_outlined,
      selectedIcon: Icons.home_rounded,
      label: 'Home',
    ),
    NavItem(
      icon: Icons.favorite_border_rounded,
      selectedIcon: Icons.favorite_rounded,
      label: 'Wishlist',
    ),
    NavItem(
      icon: Icons.shopping_bag_outlined,
      selectedIcon: Icons.shopping_bag_rounded,
      label: 'Cart',
    ),
    NavItem(
      icon: Icons.receipt_long_outlined,
      selectedIcon: Icons.receipt_long_rounded,
      label: 'Orders',
    ),
    NavItem(
      icon: Icons.person_outline_rounded,
      selectedIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  const CommonBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.badgeCounts = const [null, null, null, null, null],
  });

  void _handleTap(int index) {
    HapticFeedback.lightImpact();
    onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = ThemeController.isDarkMode(context);
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;
    final border = isDark ? AppColors.darkBorder : AppColors.lightBorder;

    return SafeArea(
      top: false,
      minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 280),
            curve: Curves.easeOutCubic,
            height: AppDimens.bottomNavHeight,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            decoration: BoxDecoration(
              color: bg.withValues(alpha: isDark ? 0.86 : 0.92),
              borderRadius: BorderRadius.circular(28),
              border: Border.all(color: border.withValues(alpha: 0.78)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: isDark ? 0.28 : 0.09),
                  blurRadius: 28,
                  offset: const Offset(0, 14),
                ),
                BoxShadow(
                  color: AppColors.primary.withValues(
                    alpha: isDark ? 0.08 : 0.10,
                  ),
                  blurRadius: 22,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemWidth = constraints.maxWidth / _items.length;
                return Stack(
                  children: [
                    AnimatedPositioned(
                      duration: const Duration(milliseconds: 340),
                      curve: Curves.easeOutCubic,
                      left: itemWidth * currentIndex + 4,
                      top: 4,
                      bottom: 4,
                      width: itemWidth - 8,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: isDark
                                ? [
                                    AppColors.primary.withValues(alpha: 0.30),
                                    AppColors.palette02.withValues(alpha: 0.16),
                                  ]
                                : [
                                    AppColors.primary.withValues(alpha: 0.16),
                                    AppColors.palette02.withValues(alpha: 0.10),
                                  ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                          border: Border.all(
                            color: AppColors.primary.withValues(
                              alpha: isDark ? 0.22 : 0.16,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Row(
                      children: List.generate(_items.length, (index) {
                        final badge = index < badgeCounts.length
                            ? badgeCounts[index]
                            : null;
                        return Expanded(
                          child: _NavDestination(
                            item: _items[index],
                            selected: index == currentIndex,
                            badge: badge,
                            isDark: isDark,
                            onTap: () => _handleTap(index),
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _NavDestination extends StatefulWidget {
  final NavItem item;
  final bool selected;
  final int? badge;
  final bool isDark;
  final VoidCallback onTap;

  const _NavDestination({
    required this.item,
    required this.selected,
    required this.badge,
    required this.isDark,
    required this.onTap,
  });

  @override
  State<_NavDestination> createState() => _NavDestinationState();
}

class _NavDestinationState extends State<_NavDestination>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 260),
    );
    _scale = Tween<double>(
      begin: 0.92,
      end: 1.08,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));
    if (widget.selected) _controller.value = 1;
  }

  @override
  void didUpdateWidget(covariant _NavDestination oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.selected != oldWidget.selected) {
      widget.selected ? _controller.forward(from: 0) : _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.isDark ? AppColors.palette02 : AppColors.primary;
    final inactive = widget.isDark
        ? AppColors.darkTextSecondary
        : AppColors.muted;
    final color = widget.selected ? active : inactive;

    return Semantics(
      selected: widget.selected,
      button: true,
      label: widget.item.label,
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(22),
        splashColor: active.withValues(alpha: 0.08),
        highlightColor: active.withValues(alpha: 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scale,
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 220),
                transitionBuilder: (child, animation) {
                  return FadeTransition(
                    opacity: animation,
                    child: ScaleTransition(scale: animation, child: child),
                  );
                },
                child: _BadgedIcon(
                  key: ValueKey(widget.selected),
                  icon: widget.selected
                      ? widget.item.selectedIcon
                      : widget.item.icon,
                  color: color,
                  badge: widget.badge,
                  isDark: widget.isDark,
                ),
              ),
            ),
            const SizedBox(height: 4),
            AnimatedDefaultTextStyle(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOut,
              style: TextStyle(
                fontSize: widget.selected ? 11.2 : 10.4,
                fontWeight: widget.selected ? FontWeight.w800 : FontWeight.w600,
                color: color,
                letterSpacing: 0.1,
              ),
              child: Text(
                widget.item.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int? badge;
  final bool isDark;

  const _BadgedIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.badge,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color, size: 24),
        if (badge != null)
          Positioned(
            top: -6,
            right: -8,
            child: _Badge(count: badge!, isDark: isDark),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final bool isDark;

  const _Badge({required this.count, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final bg = isDark ? AppColors.darkSurface : AppColors.lightSurface;

    if (count == 0) {
      return _BadgeShell(
        isDark: isDark,
        child: const SizedBox(width: 8, height: 8),
      );
    }

    return _BadgeShell(
      isDark: isDark,
      background: bg,
      child: Text(
        count > 99 ? '99+' : '$count',
        style: const TextStyle(
          color: Colors.white,
          fontSize: 9,
          fontWeight: FontWeight.w900,
          height: 1.1,
        ),
      ),
    );
  }
}

class _BadgeShell extends StatelessWidget {
  final Widget child;
  final bool isDark;
  final Color? background;

  const _BadgeShell({
    required this.child,
    required this.isDark,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.elasticOut,
      builder: (_, scale, child) => Transform.scale(scale: scale, child: child),
      child: Container(
        padding: background == null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(
            color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
            width: 1.7,
          ),
        ),
        child: child,
      ),
    );
  }
}
