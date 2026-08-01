import 'dart:math';
import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A human-drawn, Excalidraw-inspired button.
///
/// The border is slightly imperfect (wobbled rounded rectangle), with soft
/// hover glow, gentle press scale, and a subtle accent fill on hover.
/// It feels hand-drawn but premium — not childish.
class SketchButton extends StatefulWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final Color? borderColor;
  final Color? accentColor;
  final bool outlined;
  final bool expanded;
  final double height;
  final EdgeInsetsGeometry padding;

  const SketchButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.borderColor,
    this.accentColor,
    this.outlined = false,
    this.expanded = true,
    this.height = 52,
    this.padding = const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
  });

  @override
  State<SketchButton> createState() => _SketchButtonState();
}

class _SketchButtonState extends State<SketchButton> {
  bool _hovered = false;
  bool _pressed = false;

  Color get _accent =>
      widget.accentColor ?? (widget.outlined ? AppColors.accentBlue : AppColors.accentOrange);

  Color get _borderColor => widget.borderColor ?? AppColors.borderStrong;

  @override
  Widget build(BuildContext context) {
    final labelStyle = AppTypography.labelLarge.copyWith(
      color: widget.outlined ? _accent : AppColors.background,
      fontWeight: FontWeight.w600,
    );

    final fillColor = widget.outlined
        ? AppColors.card.withValues(alpha: 0.6)
        : _accent.withValues(alpha: 0.18);

    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) {
          if (widget.onPressed != null) setState(() => _pressed = true);
        },
        onTapUp: (_) => setState(() => _pressed = false),
        onTapCancel: () => setState(() => _pressed = false),
        onTap: widget.onPressed,
        child: AnimatedScale(
          scale: _pressed ? 0.96 : 1.0,
          duration: AppSpacing.durationFast,
          curve: Curves.easeOut,
          child: AnimatedContainer(
            duration: AppSpacing.durationNormal,
            curve: Curves.easeOutCubic,
            height: widget.height,
            width: widget.expanded ? double.infinity : null,
            padding: widget.padding,
            decoration: BoxDecoration(
              color: fillColor,
              borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
              border: Border.all(
                color: _hovered ? _accent : _borderColor,
                width: _hovered ? 1.8 : 1.2,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: _accent.withValues(alpha: 0.12),
                        blurRadius: 16,
                        spreadRadius: 1,
                      ),
                    ]
                  : const [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (widget.icon != null) ...[
                  Icon(
                    widget.icon,
                    size: 18,
                    color: widget.outlined ? _accent : AppColors.background,
                  ),
                  const SizedBox(width: 8),
                ],
                Text(widget.label, style: labelStyle),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// A thin hand-drawn underline used under section headers.
class DoodleUnderline extends StatelessWidget {
  final Color color;
  final double width;

  const DoodleUnderline({super.key, this.color = AppColors.accentOrange, this.width = 64});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 8),
      painter: _DoodleLinePainter(color: color),
    );
  }
}

class _DoodleLinePainter extends CustomPainter {
  final Color color;

  _DoodleLinePainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.2
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final h = size.height / 2;
    path.moveTo(0, h);
    for (var i = 0.0; i <= size.width; i += 8) {
      path.lineTo(i, h + sin(i / 11) * 1.6);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DoodleLinePainter oldDelegate) => oldDelegate.color != color;
}
