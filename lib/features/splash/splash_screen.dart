import 'dart:async';
import 'dart:ui';

import 'package:dewmii/app/routes.dart';
import 'package:flutter/material.dart';

import '../../core/constants/app_strings.dart';
import '../../core/theme/app_theme_palette.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  static const String _logoPath = 'assets/images/logo.png';

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

    _titleOffset = Tween<Offset>(begin: const Offset(0, .25), end: Offset.zero)
        .animate(
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
    final palette = context.palette;
    final size = MediaQuery.sizeOf(context);

    return Scaffold(
      backgroundColor: palette.background,
      body: SizedBox.expand(
        child: DecoratedBox(
          decoration: BoxDecoration(gradient: palette.heroGradient),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Positioned(
                top: -size.width * .22,
                right: -size.width * .20,
                child: _GlowOrb(
                  size: size.width * .68,
                  color: palette.primary.withValues(
                    alpha: palette.isDark ? .22 : .18,
                  ),
                ),
              ),

              Positioned(
                left: -size.width * .28,
                bottom: size.height * .04,
                child: _GlowOrb(
                  size: size.width * .82,
                  color: palette.accent.withValues(
                    alpha: palette.isDark ? .16 : .13,
                  ),
                ),
              ),

              Positioned(
                top: size.height * .22,
                left: -size.width * .18,
                child: _GlowOrb(
                  size: size.width * .42,
                  color: Colors.white.withValues(
                    alpha: palette.isDark ? .05 : .20,
                  ),
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
                        child: _SplashLogo(
                          logoPath: _logoPath,
                          primaryColor: palette.primary,
                          surfaceColor: palette.surface,
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
                                style:
                                    theme.textTheme.displaySmall?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -.8,
                                      color: palette.isDark
                                          ? Colors.white
                                          : palette.textPrimary,
                                    ) ??
                                    TextStyle(
                                      fontSize: 38,
                                      fontWeight: FontWeight.w900,
                                      color: palette.isDark
                                          ? Colors.white
                                          : palette.textPrimary,
                                    ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                'Shop smarter. Live better.',
                                textAlign: TextAlign.center,
                                style: theme.textTheme.bodyLarge?.copyWith(
                                  color:
                                      (palette.isDark
                                              ? Colors.white
                                              : palette.textPrimary)
                                          .withValues(alpha: .68),
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
                                  palette.primary,
                                ),
                                backgroundColor: palette.primary.withValues(
                                  alpha: .14,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            Text(
                              'Preparing your store...',
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: palette.textPrimary.withValues(
                                  alpha: .62,
                                ),
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
      ),
    );
  }
}

class _SplashLogo extends StatelessWidget {
  final String logoPath;
  final Color primaryColor;
  final Color surfaceColor;

  const _SplashLogo({
    required this.logoPath,
    required this.primaryColor,
    required this.surfaceColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 126,
      height: 126,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(36),
        color: surfaceColor.withValues(alpha: .92),
        border: Border.all(color: Colors.white.withValues(alpha: .32)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withValues(alpha: .26),
            blurRadius: 38,
            offset: const Offset(0, 18),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: .10),
            blurRadius: 22,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Image.asset(
        logoPath,
        fit: BoxFit.contain,
        errorBuilder: (context, error, stackTrace) {
          return Icon(
            Icons.shopping_bag_rounded,
            size: 58,
            color: primaryColor,
          );
        },
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
      child: ImageFiltered(
        imageFilter: ImageFilter.blur(sigmaX: 28, sigmaY: 28),
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
      ),
    );
  }
}
