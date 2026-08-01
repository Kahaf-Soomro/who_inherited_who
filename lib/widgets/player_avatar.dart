import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_typography.dart';

/// A circular avatar showing the first letter(s) of a player's nickname.
///
/// The background color is derived deterministically from the nickname,
/// and an optional ring highlights the current drawer / active player.
class PlayerAvatar extends StatelessWidget {
  final String name;
  final double radius;
  final bool highlighted;
  final Color? highlightColor;
  final bool showRing;

  const PlayerAvatar({
    super.key,
    required this.name,
    this.radius = 18,
    this.highlighted = false,
    this.highlightColor,
    this.showRing = false,
  });

  @override
  Widget build(BuildContext context) {
    final initials = _initials(name);
    final accent = highlighted
        ? (highlightColor ?? AppColors.accentOrange)
        : AppColors.avatarColorFor(name);

    return Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: accent.withValues(alpha: 0.16),
        border: Border.all(
          color: highlighted ? accent : accent.withValues(alpha: 0.35),
          width: highlighted ? 2 : 1.2,
        ),
      ),
      child: Center(
        child: Text(
          initials,
          style: AppTypography.labelLarge.copyWith(
            color: accent,
            fontWeight: FontWeight.w700,
            fontSize: radius * 0.72,
          ),
        ),
      ),
    );
  }

  String _initials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(RegExp(r'\s+'));
    if (parts.length >= 2) {
      final first = parts[0][0].toUpperCase();
      final last = parts[1][0].toUpperCase();
      return '$first$last';
    }
    return name.substring(0, 1).toUpperCase();
  }
}

/// A cluster of overlapping player avatars — used in room overlays.
class AvatarStack extends StatelessWidget {
  final List<String> names;
  final double radius;
  final int maxAvatars;

  const AvatarStack({
    super.key,
    required this.names,
    this.radius = 14,
    this.maxAvatars = 4,
  });

  @override
  Widget build(BuildContext context) {
    final visible = names.take(maxAvatars).toList();
    final overflow = names.length - visible.length;

    return SizedBox(
      height: radius * 2,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < visible.length; i++)
            Container(
              margin: EdgeInsets.only(left: i == 0 ? 0 : -radius * 0.4),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: AppColors.card, width: 2),
              ),
              child: PlayerAvatar(name: visible[i], radius: radius),
            ),
          if (overflow > 0)
            Container(
              margin: EdgeInsets.only(left: -radius * 0.4),
              width: radius * 2,
              height: radius * 2,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.secondary,
                border: Border.all(color: AppColors.card, width: 2),
              ),
              child: Center(
                child: Text(
                  '+$overflow',
                  style: AppTypography.labelMedium.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
