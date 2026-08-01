import 'dart:math';
import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';

/// A hand-drawn wavy separator with a small doodle accent.
///
/// Brings a subtle Excalidraw personality to section boundaries without
/// feeling childish.
class ScribbleDivider extends StatelessWidget {
  final Color color;
  final double thickness;
  final bool showStar;
  final EdgeInsetsGeometry margin;

  const ScribbleDivider({
    super.key,
    this.color = AppColors.borderStrong,
    this.thickness = 1.6,
    this.showStar = false,
    this.margin = const EdgeInsets.symmetric(vertical: 16),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: Row(
        children: [
          Expanded(
            child: CustomPaint(
              size: const Size(double.infinity, 10),
              painter: _WavyLinePainter(color: color, thickness: thickness),
            ),
          ),
          if (showStar) ...[
            const SizedBox(width: 12),
            CustomPaint(
              size: const Size(18, 18),
              painter: _DoodleStarPainter(color: color, thickness: thickness),
            ),
            const SizedBox(width: 12),
          ],
        ],
      ),
    );
  }
}

class _WavyLinePainter extends CustomPainter {
  final Color color;
  final double thickness;

  _WavyLinePainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;

    final path = Path();
    final midY = size.height / 2;
    final waveLength = 22.0;
    final amplitude = 2.6;

    path.moveTo(0, midY);
    var x = 0.0;
    var sign = 1.0;
    while (x < size.width) {
      x += waveLength;
      if (x > size.width) x = size.width;
      path.lineTo(x, midY + sign * amplitude * (x / waveLength).clamp(0.4, 1.0));
      sign *= -1;
    }
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _WavyLinePainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.thickness != thickness;
}

class _DoodleStarPainter extends CustomPainter {
  final Color color;
  final double thickness;

  _DoodleStarPainter({required this.color, required this.thickness});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = thickness
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final center = Offset(size.width / 2, size.height / 2);
    final outerR = size.width / 2 - 1;
    final innerR = outerR * 0.45;
    final path = Path();

    for (var i = 0; i < 10; i++) {
      final radius = i.isEven ? outerR : innerR;
      final angle = -pi / 2 + i * pi / 5;
      final point = Offset(
        center.dx + radius * cos(angle),
        center.dy + radius * sin(angle),
      );
      if (i == 0) {
        path.moveTo(point.dx, point.dy);
      } else {
        path.lineTo(point.dx, point.dy);
      }
    }
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _DoodleStarPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.thickness != thickness;
}
