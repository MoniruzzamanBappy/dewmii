import 'dart:ui';

import 'package:dewmii/app/routes.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  late final PageController _pageController;
  late final AnimationController _floatingController;
  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  int _currentIndex = 0;

  final List<_OnboardingItem> _items = const [
    _OnboardingItem(
      icon: Icons.shopping_bag_outlined,
      title: 'Welcome to Dewmii',
      subtitle:
          'Discover beautiful products, trending collections, and everyday essentials in one modern shopping app.',
    ),
    _OnboardingItem(
      icon: Icons.local_shipping_outlined,
      title: 'Fast & Reliable Delivery',
      subtitle:
          'Track your orders, choose delivery options, and enjoy a smooth shopping journey from cart to doorstep.',
    ),
    _OnboardingItem(
      icon: Icons.verified_user_outlined,
      title: 'Secure Checkout',
      subtitle:
          'Save addresses, apply coupons, review your order, and pay safely with a clean checkout experience.',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _floatingController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2600),
    )..repeat(reverse: true);

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 850),
    )..forward();

    _fadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, .08),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOutCubic),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _floatingController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  bool get _isLastPage => _currentIndex == _items.length - 1;

  void _goToLogin() {
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _goToRegister() {
    Navigator.pushNamed(context, AppRoutes.register);
  }

  void _nextPage() {
    if (_isLastPage) {
      _goToLogin();
      return;
    }

    _pageController.nextPage(
      duration: const Duration(milliseconds: 420),
      curve: Curves.easeOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          gradient: isDark
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF101827), Color(0xFF172033), Color(0xFF0F172A)],
                )
              : AppColors.primaryGradient,
        ),
        child: SafeArea(
          child: Stack(
            children: [
              const _BackgroundGlow(),
              Positioned(
                top: 12,
                right: 18,
                child: AnimatedOpacity(
                  opacity: _isLastPage ? 0 : 1,
                  duration: const Duration(milliseconds: 250),
                  child: IgnorePointer(
                    ignoring: _isLastPage,
                    child: TextButton(
                      onPressed: _goToLogin,
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.white.withValues(alpha: .16),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 10,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(999),
                        ),
                      ),
                      child: const Text('Skip'),
                    ),
                  ),
                ),
              ),
              FadeTransition(
                opacity: _fadeAnimation,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Column(
                    children: [
                      Expanded(
                        child: PageView.builder(
                          controller: _pageController,
                          physics: const BouncingScrollPhysics(),
                          onPageChanged: (index) {
                            setState(() => _currentIndex = index);
                          },
                          itemCount: _items.length,
                          itemBuilder: (context, index) {
                            final item = _items[index];
                            return Padding(
                              padding: const EdgeInsets.fromLTRB(24, 48, 24, 12),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  AnimatedBuilder(
                                    animation: _floatingController,
                                    builder: (context, child) {
                                      final offset = lerpDouble(
                                            -8,
                                            8,
                                            _floatingController.value,
                                          ) ??
                                          0;
                                      return Transform.translate(
                                        offset: Offset(0, offset),
                                        child: child,
                                      );
                                    },
                                    child: _HeroIcon(
                                      icon: item.icon,
                                      size: size.width < 360 ? 150 : 178,
                                    ),
                                  ),
                                  const SizedBox(height: 42),
                                  AnimatedSwitcher(
                                    duration: const Duration(milliseconds: 320),
                                    transitionBuilder: (child, animation) {
                                      return FadeTransition(
                                        opacity: animation,
                                        child: SlideTransition(
                                          position: Tween<Offset>(
                                            begin: const Offset(.04, 0),
                                            end: Offset.zero,
                                          ).animate(animation),
                                          child: child,
                                        ),
                                      );
                                    },
                                    child: Column(
                                      key: ValueKey(item.title),
                                      children: [
                                        Text(
                                          item.title,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.headlineMedium?.copyWith(
                                            fontWeight: FontWeight.w900,
                                            letterSpacing: -.8,
                                            color: Colors.white,
                                          ),
                                        ),
                                        const SizedBox(height: 14),
                                        Text(
                                          item.subtitle,
                                          textAlign: TextAlign.center,
                                          style: theme.textTheme.bodyLarge?.copyWith(
                                            height: 1.55,
                                            color: Colors.white.withValues(alpha: .82),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.fromLTRB(24, 0, 24, 26),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .14),
                                borderRadius: BorderRadius.circular(30),
                                border: Border.all(
                                  color: Colors.white.withValues(alpha: .22),
                                ),
                              ),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  _PageIndicator(
                                    itemCount: _items.length,
                                    currentIndex: _currentIndex,
                                  ),
                                  const SizedBox(height: 18),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 56,
                                    child: ElevatedButton(
                                      onPressed: _nextPage,
                                      style: ElevatedButton.styleFrom(
                                        elevation: 0,
                                        backgroundColor: Colors.white,
                                        foregroundColor: AppColors.primary,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: AnimatedSwitcher(
                                        duration: const Duration(milliseconds: 220),
                                        child: Text(
                                          _isLastPage ? 'Get Started' : 'Next',
                                          key: ValueKey(_isLastPage),
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 54,
                                    child: OutlinedButton(
                                      onPressed: _goToRegister,
                                      style: OutlinedButton.styleFrom(
                                        foregroundColor: Colors.white,
                                        side: BorderSide(
                                          color: Colors.white.withValues(alpha: .45),
                                        ),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(18),
                                        ),
                                      ),
                                      child: const Text(
                                        'Create Account',
                                        style: TextStyle(fontWeight: FontWeight.w800),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeroIcon extends StatelessWidget {
  const _HeroIcon({required this.icon, required this.size});

  final IconData icon;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withValues(alpha: .98),
            Colors.white.withValues(alpha: .72),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: .16),
            blurRadius: 44,
            offset: const Offset(0, 24),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            width: size * .68,
            height: size * .68,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: .10),
              shape: BoxShape.circle,
            ),
          ),
          Icon(icon, size: size * .38, color: AppColors.primary),
        ],
      ),
    );
  }
}

class _PageIndicator extends StatelessWidget {
  const _PageIndicator({required this.itemCount, required this.currentIndex});

  final int itemCount;
  final int currentIndex;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(itemCount, (index) {
        final selected = index == currentIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 260),
          curve: Curves.easeOutCubic,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          width: selected ? 26 : 8,
          height: 8,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: selected ? 1 : .38),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _BackgroundGlow extends StatelessWidget {
  const _BackgroundGlow();

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: -70,
          left: -40,
          child: _GlowCircle(size: 190, opacity: .20),
        ),
        Positioned(
          top: 180,
          right: -80,
          child: _GlowCircle(size: 230, opacity: .16),
        ),
        Positioned(
          bottom: 130,
          left: -90,
          child: _GlowCircle(size: 260, opacity: .13),
        ),
      ],
    );
  }
}

class _GlowCircle extends StatelessWidget {
  const _GlowCircle({required this.size, required this.opacity});

  final double size;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

class _OnboardingItem {
  const _OnboardingItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}
