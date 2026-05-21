import 'dart:async';
import 'dart:math' as math;

import 'package:dewmii/app/routes.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _introController;
  late final AnimationController _pulseController;
  late final Animation<double> _logoScale;
  late final Animation<double> _logoOpacity;
  late final Animation<Offset> _titleOffset;
  Timer? _navigationTimer;

  @override
  void initState() {
    super.initState();

    _introController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1150),
    );

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1700),
    )..repeat(reverse: true);

    _logoScale = CurvedAnimation(
      parent: _introController,
      curve: Curves.elasticOut,
    );

    _logoOpacity = CurvedAnimation(
      parent: _introController,
      curve: const Interval(0, .65, curve: Curves.easeOut),
    );

    _titleOffset = Tween<Offset>(
      begin: const Offset(0, .25),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _introController,
        curve: const Interval(.25, 1, curve: Curves.easeOutCubic),
      ),
    );

    _introController.forward();

    _navigationTimer = Timer(const Duration(milliseconds: 2300), () {
      if (!mounted) return;
      Navigator.pushReplacementNamed(context, AppRoutes.onboarding);
    });
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _introController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final colorScheme = theme.colorScheme;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: isDark
                ? const [
                    Color(0xFF100811),
                    Color(0xFF201128),
                    Color(0xFF331923),
                  ]
                : const [
                    Color(0xFFFFFBF8),
                    Color(0xFFFFEEF5),
                    Color(0xFFFFE4D9),
                  ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: -size.width * .22,
              right: -size.width * .2,
              child: _GlowOrb(
                size: size.width * .68,
                color: colorScheme.primary.withValues(alpha: isDark ? .2 : .16),
              ),
            ),
            Positioned(
              left: -size.width * .28,
              bottom: size.height * .04,
              child: _GlowOrb(
                size: size.width * .82,
                color: const Color(0xFFFF7A59).withValues(alpha: isDark ? .16 : .13),
              ),
            ),
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 28),
                child: Column(
                  children: [
                    const Spacer(),
                    AnimatedBuilder(
                      animation: Listenable.merge([
                        _introController,
                        _pulseController,
                      ]),
                      builder: (context, child) {
                        final pulse = 1 + (_pulseController.value * .045);
                        return Opacity(
                          opacity: _logoOpacity.value,
                          child: Transform.scale(
                            scale: _logoScale.value * pulse,
                            child: child,
                          ),
                        );
                      },
                      child: _BrandMark(
                        foregroundColor: isDark
                            ? Colors.white
                            : const Color(0xFF1E0D16),
                        accentColor: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 28),
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: SlideTransition(
                        position: _titleOffset,
                        child: Column(
                          children: [
                            Text(
                              AppStrings.appName,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.displaySmall?.copyWith(
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -.8,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1E0D16),
                                  ) ??
                                  TextStyle(
                                    fontSize: 38,
                                    fontWeight: FontWeight.w900,
                                    color: isDark
                                        ? Colors.white
                                        : const Color(0xFF1E0D16),
                                  ),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Shop smarter. Live better.',
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyLarge?.copyWith(
                                color: (isDark
                                        ? Colors.white
                                        : const Color(0xFF1E0D16))
                                    .withValues(alpha: .66),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Spacer(),
                    FadeTransition(
                      opacity: _logoOpacity,
                      child: Column(
                        children: [
                          SizedBox(
                            width: 38,
                            height: 38,
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                colorScheme.primary,
                              ),
                              backgroundColor: colorScheme.primary.withValues(alpha: .12),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Preparing your store...',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurface.withValues(alpha: .6),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 34),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BrandMark extends StatelessWidget {
  const _BrandMark({
    required this.foregroundColor,
    required this.accentColor,
  });

  final Color foregroundColor;
  final Color accentColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 116,
      height: 116,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(34),
        color: Colors.white.withValues(alpha: .18),
        border: Border.all(color: Colors.white.withValues(alpha: .22)),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: .24),
            blurRadius: 34,
            offset: const Offset(0, 18),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Transform.rotate(
            angle: -math.pi / 18,
            child: Container(
              width: 62,
              height: 62,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(18),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    accentColor.withValues(alpha: .95),
                    const Color(0xFFFF7A59),
                  ],
                ),
              ),
            ),
          ),
          Icon(
            Icons.shopping_bag_rounded,
            size: 54,
            color: foregroundColor,
          ),
          Positioned(
            top: 24,
            right: 29,
            child: Container(
              width: 11,
              height: 11,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GlowOrb extends StatelessWidget {
  const _GlowOrb({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
        ),
      ),
    );
  }
}
