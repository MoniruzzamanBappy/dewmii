import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_controller.dart';

enum ToastType { success, error, warning, info }

class AppToast {
  AppToast._();

  static OverlayEntry? _current;

  static void show(
    BuildContext context, {
    required String message,
    ToastType type = ToastType.info,
    Duration duration = const Duration(seconds: 3),
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    _current?.remove();

    final overlay = Overlay.of(context);

    _current = OverlayEntry(
      builder: (_) => _ToastOverlay(
        message: message,
        type: type,
        duration: duration,
        actionLabel: actionLabel,
        onAction: onAction,
        onDismiss: () {
          _current?.remove();
          _current = null;
        },
      ),
    );

    overlay.insert(_current!);
  }

  static void dismiss() {
    _current?.remove();
    _current = null;
  }
}

// ─── Overlay positioned wrapper ───────────────────────────────────────────

class _ToastOverlay extends StatelessWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;

  const _ToastOverlay({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 12,
      left: 16,
      right: 16,
      child: Material(
        color: Colors.transparent,
        child: _ToastCard(
          message: message,
          type: type,
          duration: duration,
          actionLabel: actionLabel,
          onAction: onAction,
          onDismiss: onDismiss,
        ),
      ),
    );
  }
}

// ─── Toast card with animation + progress + swipe ────────────────────────

class _ToastCard extends StatefulWidget {
  final String message;
  final ToastType type;
  final Duration duration;
  final String? actionLabel;
  final VoidCallback? onAction;
  final VoidCallback onDismiss;

  const _ToastCard({
    required this.message,
    required this.type,
    required this.duration,
    required this.onDismiss,
    this.actionLabel,
    this.onAction,
  });

  @override
  State<_ToastCard> createState() => _ToastCardState();
}

class _ToastCardState extends State<_ToastCard> with TickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final AnimationController _progressCtrl;

  late final Animation<Offset> _slide;
  late final Animation<double> _fade;
  late final Animation<double> _progress;

  bool _dismissing = false;

  @override
  void initState() {
    super.initState();

    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 320),
    );

    _progressCtrl = AnimationController(vsync: this, duration: widget.duration);

    _slide = Tween<Offset>(
      begin: const Offset(0, -0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOutCubic));

    _fade = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);

    _progress = Tween<double>(begin: 1.0, end: 0.0).animate(_progressCtrl);

    _ctrl.forward();
    _progressCtrl.forward();

    Future.delayed(widget.duration, _autoDismiss);
  }

  Future<void> _autoDismiss() async {
    if (!mounted || _dismissing) return;
    await _dismiss();
  }

  Future<void> _dismiss() async {
    if (_dismissing || !mounted) return;

    _dismissing = true;

    await _ctrl.reverse();

    if (mounted) {
      widget.onDismiss();
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _progressCtrl.dispose();
    super.dispose();
  }

  // ── Design tokens per type ───────────────────────────────────────────────

  Color get _iconBg {
    switch (widget.type) {
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

  Color get _progressColor => _iconBg;

  Color _surfaceColor(BuildContext context) {
    final isDark = ThemeController.isDarkMode(context);
    return isDark ? AppColors.darkSurface : AppColors.lightSurface;
  }

  Color _textColor(BuildContext context) {
    final isDark = ThemeController.isDarkMode(context);
    return isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  }

  Color _subtextColor(BuildContext context) {
    final isDark = ThemeController.isDarkMode(context);
    return isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  }

  Color _borderColor(BuildContext context) {
    final isDark = ThemeController.isDarkMode(context);
    return isDark ? AppColors.darkBorder : AppColors.lightBorder;
  }

  IconData get _icon {
    switch (widget.type) {
      case ToastType.success:
        return Icons.check_circle_rounded;
      case ToastType.error:
        return Icons.error_rounded;
      case ToastType.warning:
        return Icons.warning_amber_rounded;
      case ToastType.info:
        return Icons.info_rounded;
    }
  }

  String get _typeLabel {
    switch (widget.type) {
      case ToastType.success:
        return 'Success';
      case ToastType.error:
        return 'Error';
      case ToastType.warning:
        return 'Warning';
      case ToastType.info:
        return 'Info';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slide,
      child: FadeTransition(
        opacity: _fade,
        child: Dismissible(
          key: UniqueKey(),
          direction: DismissDirection.up,
          onDismissed: (_) => widget.onDismiss(),
          child: Container(
            decoration: BoxDecoration(
              color: _surfaceColor(context),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: _borderColor(context)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                  spreadRadius: 0,
                ),
                BoxShadow(
                  color: _iconBg.withValues(alpha: 0.12),
                  blurRadius: 16,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Icon pill
                      Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          color: _iconBg.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Icon(_icon, color: _iconBg, size: 20),
                      ),

                      const SizedBox(width: 12),

                      // Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _typeLabel,
                              style: TextStyle(
                                color: _iconBg,
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.message,
                              style: TextStyle(
                                color: _textColor(context),
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                                height: 1.4,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 8),

                      // Dismiss
                      GestureDetector(
                        onTap: _dismiss,
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: _subtextColor(context),
                        ),
                      ),
                    ],
                  ),
                ),

                // Action row
                if (widget.actionLabel != null)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(14, 0, 14, 10),
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          widget.onAction?.call();
                          _dismiss();
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: _iconBg,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          minimumSize: Size.zero,
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                        child: Text(widget.actionLabel!),
                      ),
                    ),
                  ),

                // Progress bar
                AnimatedBuilder(
                  animation: _progress,
                  builder: (_, _) => LinearProgressIndicator(
                    value: _progress.value,
                    minHeight: 3,
                    backgroundColor: _borderColor(context),
                    valueColor: AlwaysStoppedAnimation<Color>(_progressColor),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
