import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/theme/app_theme_palette.dart';
import '../../../core/theme/theme_controller.dart';

class AdminBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AdminBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  static const List<_AdminNavItem> _items = [
    _AdminNavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard_rounded,
    ),
    _AdminNavItem(
      label: 'Products',
      icon: Icons.inventory_2_outlined,
      activeIcon: Icons.inventory_2_rounded,
    ),
    _AdminNavItem(
      label: 'Categories',
      icon: Icons.category_outlined,
      activeIcon: Icons.category_rounded,
    ),
    _AdminNavItem(
      label: 'Orders',
      icon: Icons.receipt_long_outlined,
      activeIcon: Icons.receipt_long_rounded,
    ),
    _AdminNavItem(
      label: 'Users',
      icon: Icons.people_outline_rounded,
      activeIcon: Icons.people_rounded,
    ),
  ];

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
                            return Expanded(
                              child: _AdminNavDestination(
                                item: _items[index],
                                selected: index == currentIndex,
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

class _AdminNavDestination extends StatefulWidget {
  final _AdminNavItem item;
  final bool selected;
  final AppThemePalette palette;
  final VoidCallback onTap;

  const _AdminNavDestination({
    required this.item,
    required this.selected,
    required this.palette,
    required this.onTap,
  });

  @override
  State<_AdminNavDestination> createState() => _AdminNavDestinationState();
}

class _AdminNavDestinationState extends State<_AdminNavDestination>
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

    if (widget.selected) {
      _controller.value = 1;
    }
  }

  @override
  void didUpdateWidget(covariant _AdminNavDestination oldWidget) {
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
                child: Icon(
                  widget.selected ? widget.item.activeIcon : widget.item.icon,
                  key: ValueKey('${widget.item.label}-${widget.selected}'),
                  color: color,
                  size: 24,
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

class _AdminNavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _AdminNavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
