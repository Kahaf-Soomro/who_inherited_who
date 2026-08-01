import 'dart:math';
import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';

/// A hand-drawn checkmark with a satisfying draw-in animation.
///
/// Used to celebrate correct guesses and completed actions in a playful,
/// Excalidraw-inspired way.
class SketchCheckmark extends StatefulWidget {
  final Color color;
  final double size;
  final bool animate;

  const SketchCheckmark({
    super.key,
    this.color = AppColors.accentGreen,
    this.size = 28,
    this.animate = true,
  });

  @override
  State<SketchCheckmark> createState() => _SketchCheckmarkState();
}

class _SketchCheckmarkState extends State<SketchCheckmark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _progress;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: AppSpacing.durationSlow,
    );
    _progress = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    if (widget.animate) {
      _controller.forward();
    } else {
      _controller.value = 1;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _progress,
      builder: (context, child) {
        return CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _SketchCheckmarkPainter(
            color: widget.color,
            progress: _progress.value,
          ),
        );
      },
    );
  }
}

class _SketchCheckmarkPainter extends CustomPainter {
  final Color color;
  final double progress;

  _SketchCheckmarkPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.4
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..isAntiAlias = true;

    // Draw the checkmark in two strokes for a hand-drawn feel.
    final firstStroke = (progress * 0.65).clamp(0.0, 1.0).toDouble();
    final secondStroke = ((progress - 0.65) / 0.35).clamp(0.0, 1.0).toDouble();

    // First stroke: down-left
    final p1 = Offset(size.width * 0.12, size.height * 0.55);
    final p2 = Offset(size.width * 0.38, size.height * 0.78);

    // Second stroke: up-right
    final p3 = Offset(size.width * 0.38, size.height * 0.78);
    final p4 = Offset(size.width * 0.88, size.height * 0.22);

    if (firstStroke > 0) {
      final wobbleEnd = Offset.lerp(p1, p2, firstStroke)!;
      final path = Path();
      path.moveTo(p1.dx, p1.dy);
      final wobble = Offset(
        sin(firstStroke * 4) * 0.6,
        cos(firstStroke * 3) * 0.4,
      );
      path.lineTo(wobbleEnd.dx + wobble.dx, wobbleEnd.dy + wobble.dy);
      canvas.drawPath(path, paint);
    }

    if (secondStroke > 0) {
      final wobbleEnd = Offset.lerp(p3, p4, secondStroke)!;
      final path = Path();
      path.moveTo(p3.dx, p3.dy);
      final wobble = Offset(
        sin(secondStroke * 4) * 0.6,
        cos(secondStroke * 3) * 0.4,
      );
      path.lineTo(wobbleEnd.dx + wobble.dx, wobbleEnd.dy + wobble.dy);
      canvas.drawPath(path, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _SketchCheckmarkPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.progress != progress;
}
