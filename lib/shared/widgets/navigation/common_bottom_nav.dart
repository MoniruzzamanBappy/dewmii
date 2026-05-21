import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_theme_palette.dart';
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
    return ValueListenableBuilder<AppThemeVariant>(
      valueListenable: ThemeController.themeVariant,
      builder: (context, _, _) {
        final palette = context.palette;

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
                  color: palette.surface.withValues(
                    alpha: palette.isDark ? 0.86 : 0.92,
                  ),
                  borderRadius: BorderRadius.circular(28),
                  border: Border.all(
                    color: palette.border.withValues(alpha: 0.78),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: palette.isDark ? 0.28 : 0.09,
                      ),
                      blurRadius: 28,
                      offset: const Offset(0, 14),
                    ),
                    BoxShadow(
                      color: palette.primary.withValues(
                        alpha: palette.isDark ? 0.10 : 0.12,
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
                                colors: [
                                  palette.primary.withValues(
                                    alpha: palette.isDark ? 0.30 : 0.16,
                                  ),
                                  palette.primaryLight.withValues(
                                    alpha: palette.isDark ? 0.16 : 0.10,
                                  ),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(22),
                              border: Border.all(
                                color: palette.primary.withValues(
                                  alpha: palette.isDark ? 0.22 : 0.16,
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
                                palette: palette,
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
      },
    );
  }
}

class _NavDestination extends StatefulWidget {
  final NavItem item;
  final bool selected;
  final int? badge;
  final AppThemePalette palette;
  final VoidCallback onTap;

  const _NavDestination({
    required this.item,
    required this.selected,
    required this.badge,
    required this.palette,
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
      begin: 0.94,
      end: 1.10,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutBack));

    if (widget.selected) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _NavDestination oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.selected != oldWidget.selected) {
      if (widget.selected) {
        _controller.forward(from: 0);
      } else {
        _controller.reverse();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final active = widget.palette.primary;
    final inactive = widget.palette.muted;
    final color = widget.selected ? active : inactive;

    return Semantics(
      selected: widget.selected,
      button: true,
      label: widget.item.label,
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(22),
          splashColor: active.withValues(alpha: 0.08),
          highlightColor: active.withValues(alpha: 0.05),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 3),
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
                      key: ValueKey('${widget.item.label}-${widget.selected}'),
                      icon: widget.selected
                          ? widget.item.selectedIcon
                          : widget.item.icon,
                      color: color,
                      badge: widget.badge,
                      palette: widget.palette,
                      selected: widget.selected,
                    ),
                  ),
                ),

                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 220),
                  switchInCurve: Curves.easeOutCubic,
                  switchOutCurve: Curves.easeOutCubic,
                  transitionBuilder: (child, animation) {
                    return SizeTransition(
                      sizeFactor: animation,
                      axisAlignment: -1,
                      child: FadeTransition(opacity: animation, child: child),
                    );
                  },
                  child: widget.selected
                      ? const SizedBox(
                          key: ValueKey('selected-no-label'),
                          height: 0,
                        )
                      : Padding(
                          key: ValueKey('label-${widget.item.label}'),
                          padding: const EdgeInsets.only(top: 4),
                          child: SizedBox(
                            width: double.infinity,
                            height: 14,
                            child: Center(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  widget.item.label,
                                  maxLines: 1,
                                  softWrap: false,
                                  overflow: TextOverflow.visible,
                                  style: TextStyle(
                                    fontSize: 9.8,
                                    fontWeight: FontWeight.w600,
                                    color: color,
                                    letterSpacing: 0.05,
                                    height: 1,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BadgedIcon extends StatelessWidget {
  final IconData icon;
  final Color color;
  final int? badge;
  final AppThemePalette palette;
  final bool selected;

  const _BadgedIcon({
    super.key,
    required this.icon,
    required this.color,
    required this.badge,
    required this.palette,
    required this.selected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Icon(icon, color: color, size: selected ? 26 : 22),
        if (badge != null)
          Positioned(
            top: -6,
            right: -8,
            child: _Badge(count: badge!, palette: palette),
          ),
      ],
    );
  }
}

class _Badge extends StatelessWidget {
  final int count;
  final AppThemePalette palette;

  const _Badge({required this.count, required this.palette});

  @override
  Widget build(BuildContext context) {
    if (count == 0) {
      return _BadgeShell(
        palette: palette,
        child: const SizedBox(width: 8, height: 8),
      );
    }

    return _BadgeShell(
      palette: palette,
      background: palette.surface,
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
  final AppThemePalette palette;
  final Color? background;

  const _BadgeShell({
    required this.child,
    required this.palette,
    this.background,
  });

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.3, end: 1),
      duration: const Duration(milliseconds: 320),
      curve: Curves.elasticOut,
      builder: (_, scale, child) {
        return Transform.scale(scale: scale, child: child);
      },
      child: Container(
        padding: background == null
            ? EdgeInsets.zero
            : const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppDimens.radiusFull),
          border: Border.all(color: palette.surface, width: 1.7),
        ),
        child: child,
      ),
    );
  }
}
