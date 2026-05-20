import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../features/cart/screens/cart_screen.dart';
import '../../../features/home/home_screen.dart';
import '../../../features/order/screens/my_orders_screen.dart';
import '../../../features/profile/screens/profile_screen.dart';
import '../../../features/wishlist/screens/wishlist_screen.dart';
import 'common_bottom_nav.dart';

class MainNavigationShell extends StatefulWidget {
  final int initialIndex;

  /// Optional per-tab badge counts [home, wishlist, cart, orders, profile].
  /// Pass null for no badge, 0 for dot, positive int for count.
  final List<int?> badgeCounts;

  const MainNavigationShell({
    super.key,
    this.initialIndex = 0,
    this.badgeCounts = const [null, null, null, null, null],
  });

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  late int _currentIndex;
  late int _previousIndex;

  static const _tabCount = 5;

  final PageStorageBucket _bucket = PageStorageBucket();

  final List<Widget> _screens = const [
    KeyedSubtree(
      key: PageStorageKey('home-tab'),
      child: HomeScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('wishlist-tab'),
      child: WishlistScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('cart-tab'),
      child: CartScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('orders-tab'),
      child: MyOrdersScreen(showCommonScaffold: false),
    ),
    KeyedSubtree(
      key: PageStorageKey('profile-tab'),
      child: ProfileScreen(showCommonScaffold: false),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, _tabCount - 1);
    _previousIndex = _currentIndex;
  }

  void _changeTab(int index) {
    if (index == _currentIndex) return;
    setState(() {
      _previousIndex = _currentIndex;
      _currentIndex = index;
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
    final isDark = ThemeController.isDarkMode(context);
    final background = isDark
        ? AppColors.darkBackground
        : AppColors.lightBackground;

    return WillPopScope(
      onWillPop: _handleBack,
      child: Scaffold(
        extendBody: true,
        backgroundColor: background,
        body: PageStorage(
          bucket: _bucket,
          child: Stack(
            children: List.generate(_tabCount, (index) {
              final isActive = index == _currentIndex;
              final direction = _currentIndex >= _previousIndex ? 1.0 : -1.0;

              return _AnimatedTabLayer(
                active: isActive,
                offsetX: isActive ? 0 : 0.018 * direction,
                child: IgnorePointer(
                  ignoring: !isActive,
                  child: TickerMode(enabled: isActive, child: _screens[index]),
                ),
              );
            }),
          ),
        ),
        bottomNavigationBar: CommonBottomNav(
          currentIndex: _currentIndex,
          onTap: _changeTab,
          badgeCounts: widget.badgeCounts,
        ),
      ),
    );
  }
}

class _AnimatedTabLayer extends StatelessWidget {
  final bool active;
  final double offsetX;
  final Widget child;

  const _AnimatedTabLayer({
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
