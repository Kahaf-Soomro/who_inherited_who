import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:who_inherited_who/theme/app_colors.dart';
import 'package:who_inherited_who/theme/app_spacing.dart';
import 'package:who_inherited_who/theme/app_typography.dart';
import 'package:who_inherited_who/widgets/app_card.dart';
import 'package:who_inherited_who/widgets/room_tile.dart';
import 'package:who_inherited_who/widgets/scribble_divider.dart';

class WaitingRoomScreen extends StatefulWidget {
  final players;
  final int roomSize, totalPlayers;
  final String roomName;

  const WaitingRoomScreen({
    super.key,
    required this.players,
    required this.roomName,
    required this.roomSize,
    required this.totalPlayers,
  });

  @override
  State<WaitingRoomScreen> createState() => _WaitingRoomScreenState();
}

class _WaitingRoomScreenState extends State<WaitingRoomScreen> {
  bool _copied = false;

  Future<void> _copyRoomCode(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: widget.roomName));
    if (!mounted) return;
    setState(() => _copied = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Room code copied to clipboard'),
        behavior: SnackBarBehavior.floating,
        duration: Duration(seconds: 2),
      ),
    );
    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) setState(() => _copied = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = widget.roomSize - widget.totalPlayers;
    final progress = widget.roomSize == 0
        ? 0.0
        : (widget.totalPlayers / widget.roomSize).clamp(0.0, 1.0);

    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ─── Header ───────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
              child: Text(
                'Waiting Room',
                style: AppTypography.displaySmall.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                remaining > 0
                    ? 'Waiting for $remaining more player${remaining == 1 ? '' : 's'} to join'
                    : 'Everyone is here — the game is starting!',
                style: AppTypography.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
            ),

            // ─── Occupancy progress ───────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.lg,
                AppSpacing.xs,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${widget.totalPlayers}/${widget.roomSize} players',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        '${(progress * 100).round()}%',
                        style: AppTypography.labelMedium.copyWith(
                          color: AppColors.accentBlue,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusFull),
                    child: LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      backgroundColor: AppColors.secondary,
                      valueColor: const AlwaysStoppedAnimation(AppColors.accentBlue),
                    ),
                  ),
                ],
              ),
            ),

            // ─── Room code card ───────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              child: MouseRegion(
                cursor: SystemMouseCursors.click,
                child: GestureDetector(
                  onTap: () => _copyRoomCode(context),
                  child: AppCard(
                    padding: const EdgeInsets.all(AppSpacing.md),
                    color: AppColors.card,
                    borderColor: _copied
                        ? AppColors.accentGreen.withValues(alpha: 0.5)
                        : AppColors.borderStrong,
                    child: Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.secondary,
                            borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
                          ),
                          child: Icon(
                            _copied ? Icons.check : Icons.copy,
                            size: 18,
                            color: _copied ? AppColors.accentGreen : AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'ROOM CODE',
                                style: AppTypography.overline.copyWith(
                                  color: AppColors.textFaint,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                widget.roomName,
                                style: AppTypography.mono.copyWith(
                                  color: AppColors.textPrimary,
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 1.2,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ),
                        ),
                        Text(
                          _copied ? 'Copied!' : 'Tap to copy',
                          style: AppTypography.labelSmall.copyWith(
                            color: _copied ? AppColors.accentGreen : AppColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            const ScribbleDivider(
              margin: EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.sm,
              ),
              showStar: true,
            ),

            // ─── Player list ──────────────────────────────────────
            Expanded(
              child: ListView.builder(
                primary: true,
                padding: const EdgeInsets.only(
                  top: AppSpacing.xs,
                  bottom: AppSpacing.lg,
                ),
                itemCount: widget.totalPlayers,
                itemBuilder: (context, index) {
                  final nickname = widget.players[index]?['nickname'] ?? 'Player ${index + 1}';
                  return RoomTile(
                    nickname: nickname,
                    index: index,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
