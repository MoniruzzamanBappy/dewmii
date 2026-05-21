import 'package:flutter/material.dart';

import '../../../core/theme/app_theme_palette.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../features/admin/category_management/screens/admin_category_list_screen.dart';
import '../../../features/admin/order_management/screens/admin_order_management_screen.dart';
import '../../../features/admin/product_management/screens/admin_product_management_screen.dart';
import '../../../features/admin/screens/admin_dashboard_screen.dart';
import '../../../features/admin/user_management/screens/admin_customer_list_screen.dart';
import 'admin_bottom_nav.dart';

class AdminNavigationShell extends StatefulWidget {
  final int initialIndex;

  const AdminNavigationShell({super.key, this.initialIndex = 0});

  @override
  State<AdminNavigationShell> createState() => _AdminNavigationShellState();
}

class _AdminNavigationShellState extends State<AdminNavigationShell> {
  static const int _tabCount = 5;

  int _currentIndex = 0;
  int _previousIndex = 0;

  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> _screens = const [
    KeyedSubtree(
      key: PageStorageKey('admin-dashboard-tab'),
      child: AdminDashboardScreen(),
    ),
    KeyedSubtree(
      key: PageStorageKey('admin-products-tab'),
      child: AdminProductManagementScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('admin-categories-tab'),
      child: AdminCategoryListScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('admin-orders-tab'),
      child: AdminOrderManagementScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('admin-users-tab'),
      child: AdminCustomerListScreen(showCommonScaffold: false),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _setInitialIndex();
  }

  @override
  void didUpdateWidget(covariant AdminNavigationShell oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.initialIndex != widget.initialIndex) {
      _setInitialIndex();
    }
  }

  void _setInitialIndex() {
    final safeIndex = widget.initialIndex.clamp(0, _tabCount - 1);
    _currentIndex = safeIndex;
    _previousIndex = safeIndex;
  }

  void _changeTab(int index) {
    if (index == _currentIndex) return;

    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index.clamp(0, _tabCount - 1);
    });
  }

  Future<bool> _handleBack() async {
    if (_currentIndex != 0) {
      _changeTab(0);
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeVariant>(
      valueListenable: ThemeController.themeVariant,
      builder: (context, _, _) {
        final palette = context.palette;

        return WillPopScope(
          onWillPop: _handleBack,
          child: Scaffold(
            extendBody: false,
            backgroundColor: palette.background,
            body: ColoredBox(
              color: palette.background,
              child: PageStorage(
                bucket: _bucket,
                child: Stack(
                  children: List.generate(_tabCount, (index) {
                    final isActive = index == _currentIndex;
                    final direction = _currentIndex >= _previousIndex
                        ? 1.0
                        : -1.0;

                    return _AnimatedAdminTabLayer(
                      active: isActive,
                      offsetX: isActive ? 0 : 0.018 * direction,
                      child: IgnorePointer(
                        ignoring: !isActive,
                        child: TickerMode(
                          enabled: isActive,
                          child: _screens[index],
                        ),
                      ),
                    );
                  }),
                ),
              ),
            ),
            bottomNavigationBar: AdminBottomNav(
              currentIndex: _currentIndex,
              onTap: _changeTab,
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedAdminTabLayer extends StatelessWidget {
  final bool active;
  final double offsetX;
  final Widget child;

  const _AnimatedAdminTabLayer({
    required this.active,
    required this.offsetX,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeOutCubic,
      opacity: active ? 1 : 0,
      child: AnimatedSlide(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
        offset: Offset(offsetX, 0),
        child: child,
      ),
    );
  }
}
