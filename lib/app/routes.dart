import 'package:flutter/material.dart';

import '../features/address/screens/address_list_screen.dart';
import '../features/admin/category_management/screens/admin_add_category_screen.dart';
import '../features/admin/product_management/screens/admin_add_product_screen.dart';
import '../features/admin/screens/admin_customer_analytics_screen.dart';
import '../features/admin/screens/admin_login_screen.dart';
import '../features/admin/screens/admin_product_analytics_screen.dart';
import '../features/admin/screens/admin_sales_analytics_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/checkout/screens/checkout_screen.dart';
import '../features/notifications/screens/notification_list_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/support/screens/help_center_screen.dart';
import '../shared/widgets/admin_navigation/admin_navigation_shell.dart';
import '../shared/widgets/navigation/main_navigation_shell.dart';

class AppRoutes {
  AppRoutes._();

  // Auth
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';

  // Main shell
  static const String main = '/main';
  static const String home = '/home';

  // Main tabs
  static const String wishlist = '/wishlist';
  static const String cart = '/cart';
  static const String orders = '/orders';
  static const String profile = '/profile';

  // Feature screens
  static const String checkout = '/checkout';
  static const String addresses = '/addresses';
  static const String notifications = '/notifications';
  static const String helpCenter = '/help-center';

  // Admin shell
  static const String adminMain = '/admin/main';

  // Admin auth
  static const String adminLogin = '/admin/login';

  // Admin tabs
  static const String adminDashboard = '/admin/dashboard';
  static const String adminProducts = '/admin/products';
  static const String adminCategories = '/admin/categories';
  static const String adminOrders = '/admin/orders';
  static const String adminUsers = '/admin/users';

  // Admin analytics
  static const String adminSalesAnalytics = '/admin/analytics/sales';
  static const String adminProductAnalytics = '/admin/analytics/products';
  static const String adminCustomerAnalytics = '/admin/analytics/customers';

  // Admin product actions
  static const String adminAddProduct = '/admin/products/add';

  // Admin category actions
  static const String adminAddCategory = '/admin/categories/add';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case splash:
        return _instant(const SplashScreen(), settings);

      case onboarding:
        return _fadeScale(const OnboardingScreen(), settings);

      case login:
        return _fadeScale(const LoginScreen(), settings);

      case register:
        return _slideUp(const RegisterScreen(), settings);

      case forgotPassword:
        return _slideUp(const ForgotPasswordScreen(), settings);

      case main:
        return _fadeScale(const MainNavigationShell(), settings);

      case home:
        return _fadeScale(const MainNavigationShell(initialIndex: 0), settings);

      case wishlist:
        return _fadeScale(const MainNavigationShell(initialIndex: 1), settings);

      case cart:
        return _fadeScale(const MainNavigationShell(initialIndex: 2), settings);

      case orders:
        return _fadeScale(const MainNavigationShell(initialIndex: 3), settings);

      case profile:
        return _fadeScale(const MainNavigationShell(initialIndex: 4), settings);

      case checkout:
        return _slideUp(const CheckoutScreen(), settings);

      case addresses:
        return _slideLeft(const AddressListScreen(), settings);

      case notifications:
        return _slideLeft(const NotificationListScreen(), settings);

      case helpCenter:
        return _slideLeft(const HelpCenterScreen(), settings);

      case adminMain:
        return _fadeScale(const AdminNavigationShell(), settings);

      case adminLogin:
        return _fadeScale(const AdminLoginScreen(), settings);

      // Admin bottom-nav tabs should open inside AdminNavigationShell.
      case adminDashboard:
        return _fadeScale(
          const AdminNavigationShell(initialIndex: 0),
          settings,
        );

      case adminProducts:
        return _fadeScale(
          const AdminNavigationShell(initialIndex: 1),
          settings,
        );

      case adminCategories:
        return _fadeScale(
          const AdminNavigationShell(initialIndex: 2),
          settings,
        );

      case adminOrders:
        return _fadeScale(
          const AdminNavigationShell(initialIndex: 3),
          settings,
        );

      case adminUsers:
        return _fadeScale(
          const AdminNavigationShell(initialIndex: 4),
          settings,
        );

      // Admin analytics stay as separate pages.
      case adminSalesAnalytics:
        return _slideLeft(const AdminSalesAnalyticsScreen(), settings);

      case adminProductAnalytics:
        return _slideLeft(const AdminProductAnalyticsScreen(), settings);

      case adminCustomerAnalytics:
        return _slideLeft(const AdminCustomerAnalyticsScreen(), settings);

      // Admin action pages stay as separate pages.
      case adminAddProduct:
        return _slideUp(const AdminAddProductScreen(), settings);

      case adminAddCategory:
        return _slideUp(const AdminAddCategoryScreen(), settings);

      default:
        return _fadeScale(const SplashScreen(), settings);
    }
  }

  static Route<dynamic> _instant(Widget page, RouteSettings settings) {
    return MaterialPageRoute(builder: (_) => page, settings: settings);
  }

  static PageRouteBuilder<dynamic> _fadeScale(
    Widget page,
    RouteSettings settings,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      transitionsBuilder: (_, animation, _, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curve,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.985, end: 1).animate(curve),
            child: child,
          ),
        );
      },
    );
  }

  static PageRouteBuilder<dynamic> _slideLeft(
    Widget page,
    RouteSettings settings,
  ) {
    return _slide(page, settings, const Offset(0.08, 0));
  }

  static PageRouteBuilder<dynamic> _slideUp(
    Widget page,
    RouteSettings settings,
  ) {
    return _slide(page, settings, const Offset(0, 0.08));
  }

  static PageRouteBuilder<dynamic> _slide(
    Widget page,
    RouteSettings settings,
    Offset beginOffset,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 240),
      transitionsBuilder: (_, animation, _, child) {
        final curve = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );

        return FadeTransition(
          opacity: curve,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: beginOffset,
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
