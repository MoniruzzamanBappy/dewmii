import 'package:flutter/material.dart';

import '../features/address/screens/address_list_screen.dart';
import '../features/auth/screens/forgot_password_screen.dart';
import '../features/auth/screens/login_screen.dart';
import '../features/auth/screens/register_screen.dart';
import '../features/checkout/screens/checkout_screen.dart';
import '../features/notifications/screens/notification_list_screen.dart';
import '../features/onboarding/onboarding_screen.dart';
import '../features/splash/splash_screen.dart';
import '../features/support/screens/help_center_screen.dart';
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
    Offset begin,
  ) {
    return PageRouteBuilder<dynamic>(
      settings: settings,
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 320),
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
              begin: begin,
              end: Offset.zero,
            ).animate(curve),
            child: child,
          ),
        );
      },
    );
  }
}
