import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// Reusable button with three variants — primary, secondary, ghost.
///
/// All variants share smooth hover + press animations and consistent sizing.
class AppButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final IconData? icon;
  final bool expanded;
  final double height;
  final EdgeInsetsGeometry padding;
  final bool loading;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.icon,
    this.expanded = true,
    this.height = 46,
    this.padding = const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
    this.loading = false,
  });

  @override
  State<AppButton> createState() => _AppButtonState();
}

enum AppButtonVariant { primary, secondary, ghost }

class _AppButtonState extends State<AppButton> {
  bool _hovered = false;
  bool _pressed = false;

  Color get _foregroundColor {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return AppColors.background;
      case AppButtonVariant.secondary:
        return AppColors.textPrimary;
      case AppButtonVariant.ghost:
        return AppColors.textSecondary;
    }
  }

  Color get _backgroundColor {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return _hovered ? AppColors.accentBlue.withValues(alpha: 0.92) : AppColors.accentBlue;
      case AppButtonVariant.secondary:
        return _hovered ? AppColors.secondaryHover : AppColors.secondary;
      case AppButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  Color get _borderColor {
    switch (widget.variant) {
      case AppButtonVariant.primary:
        return Colors.transparent;
      case AppButtonVariant.secondary:
        return _hovered ? AppColors.borderStrong : AppColors.border;
      case AppButtonVariant.ghost:
        return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = widget.onPressed != null && !widget.loading;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: enabled ? (_) => setState(() => _pressed = true) : null,
        onTapUp: enabled ? (_) => setState(() => _pressed = false) : null,
        onTapCancel: enabled ? () => setState(() => _pressed = false) : null,
        onTap: enabled ? widget.onPressed : null,
        child: AnimatedScale(
          scale: _pressed && enabled ? 0.97 : 1.0,
          duration: AppSpacing.durationFast,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: AppSpacing.durationNormal,
            curve: Curves.easeOutCubic,
            height: widget.height,
            width: widget.expanded ? double.infinity : null,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: _backgroundColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
              border: Border.all(color: _borderColor),
              boxShadow: _hovered && widget.variant != AppButtonVariant.ghost
                  ? [
                      BoxShadow(
                        color: (widget.variant == AppButtonVariant.primary
                                ? AppColors.accentBlue
                                : AppColors.borderStrong)
                            .withValues(alpha: 0.15),
                        blurRadius: 14,
                        spreadRadius: 0,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.loading) ...[
                  SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: _foregroundColor.withValues(alpha: 0.7),
                    ),
                  ),
                  const SizedBox(width: 10),
                ] else if (widget.icon != null) ...[
                  Icon(widget.icon, size: 17, color: _foregroundColor),
                  const SizedBox(width: 8),
                ],
                Text(
                  widget.label,
                  style: AppTypography.labelLarge.copyWith(
                    color: _foregroundColor,
                    fontWeight: FontWeight.w600,
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
