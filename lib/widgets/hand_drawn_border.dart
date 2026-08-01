import 'dart:math';
import 'package:flutter/material.dart';

/// A subtle hand-drawn rounded rectangle border in the spirit of Excalidraw.
///
/// The border is intentionally slightly imperfect — tiny bezier wobbles along
/// the edges — but restrained enough to feel premium, not childish.
class HandDrawnBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double wobble;
  final bool fill;

  HandDrawnBorderPainter({
    required this.color,
    this.strokeWidth = 1.6,
    this.wobble = 1.2,
    this.fill = false,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    final r = size.width / 2;
    final w = size.width;
    final h = size.height;

    // 8 segments with slightly staggered control points to simulate
    // a human hand drawing a rounded rectangle.
    final points = <Offset>[];
    final segments = 10;
    for (var i = 0; i <= segments; i++) {
      final t = i / segments;
      final angle = -pi / 2 + t * pi * 2;
      final jitter = wobble * (0.5 - 0.5 * cos(t * pi * 6));
      final x = w / 2 + (r + jitter) * cos(angle);
      final y = h / 2 + (r + jitter) * sin(angle);
      points.add(Offset(x, y));
    }

    final path = Path();
    path.moveTo(points.first.dx, points.first.dy);
    for (var i = 1; i < points.length; i++) {
      final prev = points[i - 1];
      final curr = points[i];
      final mid = Offset((prev.dx + curr.dx) / 2, (prev.dy + curr.dy) / 2);
      path.quadraticBezierTo(prev.dx, prev.dy, mid.dx, mid.dy);
    }
    path.close();

    if (fill) {
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant HandDrawnBorderPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.wobble != wobble ||
        oldDelegate.fill != fill;
  }
}

/// A reusable widget that applies a hand-drawn border around its child.
class HandDrawnBorder extends StatelessWidget {
  final Widget child;
  final Color color;
  final double strokeWidth;
  final double wobble;
  final EdgeInsetsGeometry padding;
  final BorderRadius borderRadius;

  const HandDrawnBorder({
    super.key,
    required this.child,
    this.color = const Color(0xFF3A424C),
    this.strokeWidth = 1.4,
    this.wobble = 1.0,
    this.padding = const EdgeInsets.all(16),
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: HandDrawnBorderPainter(
        color: color,
        strokeWidth: strokeWidth,
        wobble: wobble,
      ),
      child: Padding(
        padding: padding,
        child: child,
      ),
    );
  }
}
