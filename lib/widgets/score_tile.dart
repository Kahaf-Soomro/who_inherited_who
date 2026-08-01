import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/widgets/player_avatar.dart';

/// A scoreboard row: rank, avatar, nickname, and points.
///
/// Highlights the current leader with an accent ring and a "leading"
/// underline. Used in the in-game scoreboard drawer and winner screens.
class ScoreTile extends StatelessWidget {
  final int rank;
  final String nickname;
  final int points;
  final bool isTopPlayer;
  final bool isCurrentUser;

  const ScoreTile({
    super.key,
    required this.rank,
    required this.nickname,
    required this.points,
    this.isTopPlayer = false,
    this.isCurrentUser = false,
  });

  @override
  Widget build(BuildContext context) {
    final rankColor = rank == 1
        ? const Color(0xFFFBBF24)
        : rank == 2
            ? const Color(0xFF94A3B8)
            : rank == 3
                ? const Color(0xFFC08457)
                : AppColors.textFaint;

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: AppSpacing.sm),
      decoration: BoxDecoration(
        color: isCurrentUser
            ? AppColors.accentBlue.withValues(alpha: 0.06)
            : AppColors.card,
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        border: Border.all(
          color: isCurrentUser
              ? AppColors.accentBlue.withValues(alpha: 0.25)
              : AppColors.border,
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '$rank',
              style: AppTypography.mono.copyWith(
                color: rankColor,
                fontWeight: FontWeight.w700,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          PlayerAvatar(name: nickname, radius: 16),
          const SizedBox(width: AppSpacing.sm + 4),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  nickname,
                  style: AppTypography.bodyMedium.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: isCurrentUser ? FontWeight.w700 : FontWeight.w500,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (isTopPlayer)
                  Text(
                    'Leading',
                    style: AppTypography.labelSmall.copyWith(
                      color: AppColors.accentOrange,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: isTopPlayer
                  ? AppColors.accentOrange.withValues(alpha: 0.12)
                  : AppColors.secondary.withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
            ),
            child: Text(
              '$points',
              style: AppTypography.mono.copyWith(
                color: isTopPlayer ? AppColors.accentOrange : AppColors.textSecondary,
                fontWeight: FontWeight.w600,
                fontSize: 13,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
