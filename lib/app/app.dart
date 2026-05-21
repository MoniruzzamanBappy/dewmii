import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../core/theme/app_theme.dart';
import '../core/theme/app_theme_palette.dart';
import '../core/theme/theme_controller.dart';
import 'routes.dart';

class DewmiiApp extends StatelessWidget {
  const DewmiiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AppThemeVariant>(
      valueListenable: ThemeController.themeVariant,
      builder: (context, variant, _) {
        final palette = AppThemePalettes.byVariant(variant);

        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.theme(palette),
          darkTheme: AppTheme.theme(palette),
          themeMode: ThemeMode.light,
          initialRoute: AppRoutes.splash,
          onGenerateRoute: AppRoutes.generateRoute,
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: mediaQuery.textScaler.clamp(
                  minScaleFactor: 0.9,
                  maxScaleFactor: 1.2,
                ),
              ),
              child: ScrollConfiguration(
                behavior: const _DewmiiScrollBehavior(),
                child: child ?? const SizedBox.shrink(),
              ),
            );
          },
        );
      },
    );
  }
}

class _DewmiiScrollBehavior extends MaterialScrollBehavior {
  const _DewmiiScrollBehavior();

  @override
  ScrollPhysics getScrollPhysics(BuildContext context) {
    return const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics());
  }
}
