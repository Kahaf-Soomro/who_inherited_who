import 'dart:math';
import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A section header with optional doodle underline and trailing widget.
///
/// Used to add whitespace and clear hierarchy to every screen.
class SectionHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final bool showDoodle;
  final Color doodleColor;
  final EdgeInsetsGeometry padding;

  const SectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
    this.showDoodle = false,
    this.doodleColor = AppColors.accentOrange,
    this.padding = const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.sm),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: AppTypography.displaySmall),
                if (subtitle != null) ...[
                  const SizedBox(height: 4),
                  Text(
                    subtitle!,
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textSecondary),
                  ),
                ],
                if (showDoodle) ...[
                  const SizedBox(height: 6),
                  _DoodleLine(width: 42, color: doodleColor),
                ],
              ],
            ),
          ),
          if (trailing != null) ...[
            const SizedBox(width: AppSpacing.md),
            trailing!,
          ],
        ],
      ),
    );
  }
}

class _DoodleLine extends StatelessWidget {
  final double width;
  final Color color;

  const _DoodleLine({required this.width, required this.color});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, 6),
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
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final midY = size.height / 2;
    path.moveTo(0, midY);
    for (var x = 0.0; x <= size.width; x += 4) {
      path.lineTo(x, midY + sin(x / 10) * 1.2);
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DoodleLinePainter oldDelegate) => oldDelegate.color != color;
}
