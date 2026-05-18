import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  AppToast._();

  static OverlayEntry? _currentToast;

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
  }) {
    _currentToast?.remove();

    final overlay = Overlay.of(context);
    final color = _getColor(type);
    final icon = _getIcon(type);

    _currentToast = OverlayEntry(
      builder: (context) {
        return Positioned(
          top: MediaQuery.of(context).padding.top + 16,
          left: 16,
          right: 16,
          child: Material(
            color: Colors.transparent,
            child: _ToastBody(message: message, color: color, icon: icon),
          ),
        );
      },
    );

    overlay.insert(_currentToast!);

    Future.delayed(duration, () {
      _currentToast?.remove();
      _currentToast = null;
    });
  }

  static Color _getColor(ToastType type) {
    switch (type) {
      case ToastType.success:
        return AppColors.success;
      case ToastType.error:
        return AppColors.error;
      case ToastType.warning:
        return AppColors.warning;
      case ToastType.info:
        return AppColors.primary;
    }
  }

  static IconData _getIcon(ToastType type) {
    switch (type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }
}

class _ToastBody extends StatefulWidget {
  final String message;
  final Color color;
  final IconData icon;

  const _ToastBody({
    required this.message,
    required this.color,
    required this.icon,
  });

  @override
  State<_ToastBody> createState() => _ToastBodyState();
}

class _ToastBodyState extends State<_ToastBody>
    with SingleTickerProviderStateMixin {
  late final AnimationController controller;
  late final Animation<Offset> slideAnimation;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    super.initState();

    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 280),
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, -0.4),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: controller, curve: Curves.easeOutBack));

    fadeAnimation = CurvedAnimation(parent: controller, curve: Curves.easeOut);

    controller.forward();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: widget.color.withValues(alpha: 0.35),
                blurRadius: 24,
                offset: const Offset(0, 12),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(widget.icon, color: Colors.white, size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.message,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    height: 1.3,
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
