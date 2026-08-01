import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';

/// A clean card with thin border, rounded corners, and no shadow.
///
/// Optional hover lift for interactive cards. Supports padding, a custom
/// background, and a leading/trailing pattern for list-style cards.
class AppCard extends StatefulWidget {
  final Widget child;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;
  final Color? color;
  final Color? borderColor;
  final double radius;
  final bool interactive;
  final VoidCallback? onTap;
  final Widget? trailing;
  final Widget? leading;
  final BorderRadius? borderRadius;

  const AppCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSpacing.lg),
    this.margin = EdgeInsets.zero,
    this.color,
    this.borderColor,
    this.radius = AppSpacing.radiusMd,
    this.interactive = false,
    this.onTap,
    this.trailing,
    this.leading,
    this.borderRadius,
  });

  @override
  State<AppCard> createState() => _AppCardState();
}

class _AppCardState extends State<AppCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final borderRadiusValue = widget.borderRadius ??
        BorderRadius.circular(widget.radius);

    final card = AnimatedContainer(
      duration: AppSpacing.durationNormal,
      curve: Curves.easeOutCubic,
      margin: widget.margin,
      padding: widget.padding,
      decoration: BoxDecoration(
        color: widget.color ?? AppColors.card,
        borderRadius: borderRadiusValue,
        border: Border.all(
          color: _hovered ? (widget.borderColor ?? AppColors.borderStrong) : (widget.borderColor ?? AppColors.border),
          width: _hovered ? 1.3 : 1,
        ),
      ),
      child: widget.child,
    );

    if (!widget.interactive) return card;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _hovered ? 1.012 : 1.0,
          duration: AppSpacing.durationFast,
          curve: Curves.easeOut,
          child: card,
        ),
      ),
    );
  }
}
