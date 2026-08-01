import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A minimal pill tag/badge with optional dot indicator.
///
/// Used for status labels like "Drawing", "Guessing", "Host", etc.
class AppBadge extends StatelessWidget {
  final String label;
  final Color color;
  final bool outlined;
  final bool showDot;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.color = AppColors.accentBlue,
    this.outlined = false,
    this.showDot = false,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: outlined ? Colors.transparent : color.withValues(alpha: 0.14),
        borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
        border: outlined ? Border.all(color: color.withValues(alpha: 0.5), width: 1) : null,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showDot) ...[
            Container(
              width: 6,
              height: 6,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(
              color: outlined ? color : color,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
