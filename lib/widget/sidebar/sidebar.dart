import 'package:flutter/material.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/widgets/score_tile.dart';

class PlayerScoreBoardDrawer extends StatelessWidget {
  final List<Map> playerData;

  const PlayerScoreBoardDrawer({
    super.key,
    required this.playerData,
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: AppColors.backgroundElevated,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.horizontal(
          right: Radius.circular(AppSpacing.radiusLg),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ─── Header ─────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.lg,
              AppSpacing.xl,
              AppSpacing.lg,
              AppSpacing.md,
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Icon(
                    Icons.emoji_events_outlined,
                    size: 18,
                    color: AppColors.accentOrange,
                  ),
                ),
                const SizedBox(width: AppSpacing.sm + 4),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Scoreboard',
                      style: AppTypography.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      '${playerData.length} player${playerData.length == 1 ? '' : 's'}',
                      style: AppTypography.bodySmall.copyWith(
                        color: AppColors.textMuted,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const Divider(height: 1),

          // ─── Player scores ──────────────────────────────────────
          if (playerData.isEmpty)
            const Expanded(
              child: Center(
                child: Text(
                  'No scores yet',
                  style: TextStyle(color: AppColors.textMuted),
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                itemCount: playerData.length,
                itemBuilder: (context, index) {
                  // Determine a stable player name for avatar colors.
                  final name = playerData[index]['username']?.toString() ?? 'Player ${index + 1}';
                  int points = 0;
                  final rawPoints = playerData[index]['points'];
                  if (rawPoints is int) {
                    points = rawPoints;
                  } else {
                    points = int.tryParse(rawPoints?.toString() ?? '') ?? 0;
                  }

                  return ScoreTile(
                    rank: index + 1,
                    nickname: name,
                    points: points,
                    isTopPlayer: index == 0,
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}
